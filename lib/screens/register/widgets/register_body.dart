import 'package:chatapp/screens/register/widgets/register_form.dart';
import 'package:chatapp/services/navigation_services.dart';
import 'package:chatapp/widgets/create_account_link.dart';
import 'package:chatapp/widgets/header_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  bool isLoading = false;

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
              text: "Let's, get going!",
              title: "Register an account using the form below"),
          if (!isLoading) const RegisterForm(),
          if (!isLoading)
            CreateAccountLink(
              onPressed: () => navigationServices.goBack(),
              text: "Already have an account? ",
              btnText: "Login",
            ),
        ],
      ),
    ));
  }
}
