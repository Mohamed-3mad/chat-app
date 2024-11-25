import 'dart:io';

import 'package:chatapp/models/chat.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/services/media_service.dart';
import 'package:chatapp/services/storage_service.dart';
import 'package:chatapp/utils.dart';
import 'package:chatapp/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatScreen extends StatefulWidget {
  final UserProfile chatUser;
  const ChatScreen({super.key, required this.chatUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GetIt _getIt = GetIt.instance;

  late AuthServices _authServices;
  late DatabaseService _databaseService;
  late MediaService _mediaService;
  late StorageService _storageService;

  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    _authServices = _getIt.get<AuthServices>();
    _databaseService = _getIt.get<DatabaseService>();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();

    currentUser = ChatUser(
      id: _authServices.user!.uid,
      firstName: _authServices.user!.displayName,
    );

    otherUser = ChatUser(
      id: widget.chatUser.uid!,
      firstName: widget.chatUser.name,
      profileImage: widget.chatUser.pfpUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ChatTile(userProfile: widget.chatUser),
      ),
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return StreamBuilder(
        stream: _databaseService.getChatData(currentUser!.id, otherUser!.id),
        builder: (context, snapshot) {
          Chat? chat = snapshot.data?.data();
          List<ChatMessage> messages = [];
          if (chat != null && chat.messages != null) {
            messages = _generateChatMessagesList(chat.messages!);
          }
          return DashChat(
            messageOptions: const MessageOptions(
              showOtherUsersAvatar: true,
              showTime: true,
            ),
            inputOptions: InputOptions(
              alwaysShowSend: true,
              trailing: [
                mediaIconButton(context),
              ],
            ),
            currentUser: currentUser!,
            onSend: _sendMessage,
            messages: messages,
          );
        });
  }

  IconButton mediaIconButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          String chatId =
              generateChatId(uid1: currentUser!.id, uid2: otherUser!.id);
          String? downloadUrl = await _storageService.uploadImageToChat(
              file: file, chatId: chatId);
          if (downloadUrl != null) {
            ChatMessage chatMessage = ChatMessage(
                user: currentUser!,
                createdAt: DateTime.now(),
                medias: [
                  ChatMedia(
                      url: downloadUrl, fileName: "", type: MediaType.image)
                ]);
            _sendMessage(chatMessage);
          }
        }
      },
      icon: Icon(
        Icons.image,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message message = Message(
          senderId: chatMessage.user.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.image,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
        );
        await _databaseService.senChatMessage(
          currentUser!.id,
          otherUser!.id,
          message,
        );
      }
    } else {
      Message message = Message(
        senderId: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
      );
      await _databaseService.senChatMessage(
        currentUser!.id,
        otherUser!.id,
        message,
      );
    }
  }

  List<ChatMessage> _generateChatMessagesList(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map((m) {
      if (m.messageType == MessageType.image) {
        return ChatMessage(
          user: m.senderId == currentUser!.id ? currentUser! : otherUser!,
          createdAt: m.sentAt!.toDate(),
          medias: [
            ChatMedia(
              url: m.content!,
              fileName: "",
              type: MediaType.image,
            ),
          ],
        );
      } else {
        return ChatMessage(
          user: m.senderId == currentUser!.id ? currentUser! : otherUser!,
          text: m.content!,
          createdAt: m.sentAt!.toDate(),
        );
      }
    }).toList();
    chatMessages.sort(
      (a, b) {
        return b.createdAt.compareTo(a.createdAt);
      },
    );
    return chatMessages;
  }
}
