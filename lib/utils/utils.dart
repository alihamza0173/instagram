import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }

  print('No Image Selected');
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
        String content, context) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(content)));

Future showDilogueBox(BuildContext context) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
