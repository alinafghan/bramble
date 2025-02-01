import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageTextEditingController extends TextEditingController {
  final ImagePicker _picker = ImagePicker();
  String? lastPickedImage; // Store the selected image path

  Future<void> insertImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    lastPickedImage = pickedFile.path;

    if (!selection.isValid) return;

    final cursorPos = selection.baseOffset;
    text = '${text.substring(0, cursorPos)}ʉ${text.substring(cursorPos)}';
    selection = TextSelection.collapsed(offset: cursorPos + 1);
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style, // This receives the inherited style
    required bool withComposing,
  }) {
    final children = <InlineSpan>[];
    final chars = text.split('');

    for (int i = 0; i < chars.length; i++) {
      final char = chars[i];
      if (char == 'ʉ' && lastPickedImage != null) {
        children.add(WidgetSpan(
          child: SizedBox(
            width: 30,
            child: Image.file(File(lastPickedImage!)),
          ),
        ));
      } else {
        children.add(TextSpan(
          text: char,
          style: style ??
              Theme.of(context).textTheme.bodyLarge, // Use the inherited style
        ));
      }
    }

    return TextSpan(
        children: children,
        style: style ?? Theme.of(context).textTheme.bodyLarge);
  }
}
