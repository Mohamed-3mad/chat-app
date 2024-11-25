import 'package:chatapp/services/navigation_services.dart';
import 'package:chatapp/widgets/create_account_link.dart';
import 'package:chatapp/widgets/header_text.dart';
import 'package:chatapp/screens/login/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    GetIt getIt = GetIt.instance;
    NavigationServices navigationServices = getIt.get<NavigationServices>();
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          const HeaderText(
              text: "Hi, Welcome Back!",
              title: "Hello again, you've been missed"),
          const LoginForm(),
          CreateAccountLink(
            onPressed: () {
              navigationServices.pushNamed("/register");
            },
            text: "Don't have an account? ",
            btnText: "Sign Up",
          ),
        ],
      ),
    ));
  }
}
