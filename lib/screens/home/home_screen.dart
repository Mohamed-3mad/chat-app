import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/screens/chat/chat_screen.dart';
import 'package:chatapp/services/alert_service.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/services/navigation_services.dart';
import 'package:chatapp/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetIt _getIt = GetIt.instance;
  late AuthServices _authServices;
  late NavigationServices _navigationServices;
  late AlertService _alertService;
  late DatabaseService _databaseService;
  @override
  void initState() {
    super.initState();
    _authServices = _getIt.get<AuthServices>();
    _navigationServices = _getIt.get<NavigationServices>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
              onPressed: () async {
                bool result = await _authServices.logout();
                if (result) {
                  _alertService.showToast(
                    text: "Succeffully logged out!",
                    icon: Icons.check,
                  );
                  _navigationServices.pushReplacementNamed("/login");
                }
              },
              icon: const Icon(Icons.logout, color: Colors.red)),
        ],
      ),
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: _chatsList(),
      ),
    );
  }

  Widget _chatsList() {
    return StreamBuilder(
        stream: _databaseService.getUserProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Unable to load data."));
          }
          if (snapshot.hasData) {
            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserProfile user = users[index].data();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ChatTile(
                    userProfile: user,
                    onTap: () async {
                      final chatExists = await _databaseService.checkChatExists(
                          _authServices.user!.uid, user.uid!);
                      if (!chatExists) {
                        await _databaseService.createNewChat(
                            _authServices.user!.uid, user.uid!);
                      }
                      _navigationServices.push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ChatScreen(chatUser: user);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
