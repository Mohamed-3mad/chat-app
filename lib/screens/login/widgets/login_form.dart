import 'package:chatapp/constants.dart';
import 'package:chatapp/services/alert_service.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/services/navigation_services.dart';
import 'package:chatapp/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GetIt _getIt = GetIt.instance;
  late AuthServices authServices;
  late NavigationServices _navigationServices;
  late AlertService _alertService;

  @override
  void initState() {
    super.initState();
    authServices = _getIt.get<AuthServices>();
    _navigationServices = _getIt.get<NavigationServices>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey();
    String? email, password;
    return Container(
      height: MediaQuery.sizeOf(context).height * .4,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * .05),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
              validationRegExp: emailRegExp,
              hintText: "Email",
              height: MediaQuery.sizeOf(context).height * .1,
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            CustomFormField(
              obscureText: true,
              hintText: "Password",
              validationRegExp: passwordRegExp,
              height: MediaQuery.sizeOf(context).height * .1,
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: MaterialButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState?.save();
                    bool result = await authServices.login(email!, password!);
                    if (result) {
                      _navigationServices.pushReplacementNamed("/home");
                    } else {
                      _alertService.showToast(
                        text: "Failed to login, Please try again!",
                        icon: Icons.error,
                      );
                    }
                  }
                },
                color: Theme.of(context).colorScheme.primary,
                child:
                    const Text("Login", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
