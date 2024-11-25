import 'package:flutter/material.dart';

class CreateAccountLink extends StatelessWidget {
  const CreateAccountLink(
      {super.key, required this.text, required this.btnText, this.onPressed});
  final String text, btnText;
  final  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          TextButton(
              onPressed:onPressed,
              child: Text(btnText,
                  style: const TextStyle(fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}
