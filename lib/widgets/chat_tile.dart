import 'package:chatapp/models/user_profile.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final void Function()? onTap;
  const ChatTile({super.key, required this.userProfile,  this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: false,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userProfile.pfpUrl!),
      ),
      title: Text(userProfile.name!),
    );
  }
}
