import 'dart:io';

import 'package:chatapp/constants.dart';
import 'package:chatapp/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PfpSelectionField extends StatefulWidget {
  const PfpSelectionField({super.key});

  @override
  State<PfpSelectionField> createState() => _PfpSelectionFieldState();
}

class _PfpSelectionFieldState extends State<PfpSelectionField> {
  File? selectedImage;
  final GetIt _getIt = GetIt.instance;
  late MediaService _mediaService;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
  }

  @override
  Widget build(BuildContext context) {
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
            :const  NetworkImage(placeholderPFP) as ImageProvider,
      ),
    );
  }
}
