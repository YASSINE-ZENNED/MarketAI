import 'dart:io';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class SmallProductImage extends StatefulWidget {
  const SmallProductImage({
    Key? key,
    required this.isSelected,
    required this.press,
    required this.imageFile,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback press;
  final File imageFile;

  @override
  State<SmallProductImage> createState() => _SmallProductImageState();
}

class _SmallProductImageState extends State<SmallProductImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: kPrimaryColor.withOpacity(widget.isSelected ? 1 : 0),
          ),
        ),
        child: Image.file(widget.imageFile),
      ),
    );
  }
}
