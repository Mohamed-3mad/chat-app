import 'dart:io';
import 'package:chatapp/constants.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/services/alert_service.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/services/media_service.dart';
import 'package:chatapp/services/navigation_services.dart';
import 'package:chatapp/services/storage_service.dart';
import 'package:chatapp/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GetIt _getIt = GetIt.instance;

  late AuthServices _authServices;
  late NavigationServices _navigationServices;
  late AlertService _alertService;
  late MediaService _mediaService;
  late StorageService _storageService;
  late DatabaseService _databaseService;

  final GlobalKey<FormState> formKey = GlobalKey();
  String? email, password, name;
  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _authServices = _getIt.get<AuthServices>();
    _navigationServices = _getIt.get<NavigationServices>();
    _alertService = _getIt.get<AlertService>();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * .6,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * .05),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _pfpSelectionField(),
            CustomFormField(
              hintText: "Name",
              height: MediaQuery.sizeOf(context).height * .1,
              validationRegExp: nameRegExp,
              onSaved: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
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
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    if ((formKey.currentState?.validate() ?? false) &&
                        selectedImage != null) {
                      formKey.currentState?.save();
                      bool result =
                          await _authServices.signup(email!, password!);
                      if (result) {
                        String? pfpUrl = await _storageService.uploadUserPfp(
                          file: selectedImage!,
                          uid: _authServices.user!.uid,
                        );
                        if (pfpUrl != null) {
                          await _databaseService.createUserProfile(
                              userProfile: UserProfile(
                                  uid: _authServices.user!.uid,
                                  name: name,
                                  pfpUrl: pfpUrl));
                        }

                        _alertService.showToast(
                          text: "Welcome $name!",
                          icon: Icons.check,
                        );
                        _navigationServices.goBack();
                        _navigationServices.pushReplacementNamed("/home");
                      } else {
                        throw Exception(
                            "Unable to upload user profile picture");
                      }
                    } else {
                      throw Exception("Unable to register user");
                    }
                  } catch (e) {
                    _alertService.showToast(
                        text: "Failed to register, Please try again!",
                        icon: Icons.error);
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                color: Theme.of(context).colorScheme.primary,
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text("Register",
                        style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * .15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : const NetworkImage(placeholderPFP) as ImageProvider,
      ),
    );
  }
}
