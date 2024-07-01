import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';
import 'SmallProductImage.dart';

class ProductImages extends StatefulWidget {

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  List<File> _images = [];

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
        selectedImage = 0;  // Reset to the first image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _images.isEmpty
            ? SizedBox(
          width: 238,
          child: AspectRatio(
            aspectRatio: 1,
            child: Placeholder(),
          ),
        )
            : SizedBox(
          width: 238,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.file(_images[selectedImage]),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              _images.length,
                  (index) => SmallProductImage(
                isSelected: index == selectedImage,
                press: () {
                  setState(() {
                    selectedImage = index;
                  });
                },
                imageFile: _images[index],
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _pickImages,
          child: Text("Pick Images"),
        ),
      ],
    );
  }
}
