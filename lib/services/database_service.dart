import 'package:chatapp/models/chat.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final GetIt _getIt = GetIt.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late AuthServices _authServices;

  CollectionReference? _userCollection;
  CollectionReference? _chatCollection;
  DatabaseService() {
    _authServices = _getIt.get<AuthServices>();
    _setupCollectionReference();
  }
  void _setupCollectionReference() {
    _userCollection =
        _firebaseFirestore.collection("users").withConverter<UserProfile>(
              fromFirestore: (snapshots, _) =>
                  UserProfile.fromJson(snapshots.data()!),
              toFirestore: (userProfile, _) => userProfile.toJson(),
            );

    _chatCollection =
        _firebaseFirestore.collection("chats").withConverter<Chat>(
              fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
              toFirestore: (chat, _) => chat.toJson(),
            );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _userCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfiles() {
    return _userCollection
        ?.where("uid", isNotEqualTo: _authServices.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final result = await _chatCollection?.doc(chatId).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = _chatCollection!.doc(chatId);
    final chat = Chat(id: chatId, participants: [uid1, uid2], messages: []);
    await docRef.set(chat);
  }

  Future<void> senChatMessage(String uid1, String uid2, Message message) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = _chatCollection!.doc(chatId);
    await docRef.update(
      {
        "messages": FieldValue.arrayUnion([
          message.toJson(),
        ]),
      },
    );
  }

  Stream<DocumentSnapshot<Chat>> getChatData(String uid1,String uid2){
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    return _chatCollection!.doc(chatId).snapshots() as Stream<DocumentSnapshot<Chat>>;
  }
}
