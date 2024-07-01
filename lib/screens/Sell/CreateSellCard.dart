import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';
import '../../models/Product.dart';
import '../cart/cart_screen.dart';
import 'components/SmallProductImage.dart';
import 'components/color_dots.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';

class CreateSellCard extends StatefulWidget {
  const CreateSellCard({Key? key}) : super(key: key);
  static String routeName = "/CreateSellCard";

  @override
  _CreateSellCardState createState() => _CreateSellCardState();
}

class _CreateSellCardState extends State<CreateSellCard> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  TextEditingController keywordsController = TextEditingController();
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
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    keywordsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
      body: ListView(
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

          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Product Title",
                      border: OutlineInputBorder(),
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: 12), // Add some space between fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Product Description",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3, // Allows multiple lines for the description
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: 12), // Add some space between fields

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Price",
                      border: OutlineInputBorder(),
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          color: const Color(0xFFF5F6F9),
          child: Row(
            children: [
              Expanded(
                flex: 8, // Takes 80% of the available space
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle action for the first button
                      _postProductForSale();
                    },
                    child: const Text("Post product for sale"),
                  ),
                ),
              ),
              Expanded(
                flex: 3, // Takes 20% of the available space
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle action for the second button
                      _showAIDialog(context);
                    },
                    child: const Text("AI"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _postProductForSale() {
    // Implement your logic for posting the product for sale
    // This method will be called when "Post product for sale" button is pressed
  }

  void _showAIDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Enter Keywords"),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
              content: TextField(
                controller: keywordsController,
                onChanged: (value) {
                  // Handle text changes if needed
                },
                decoration: InputDecoration(hintText: "Enter keywords"),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Handle keyword generation logic
                    setState(() {
                      _titleController.text = "CreateSellCard";
                      _descriptionController.text = "test test";
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Generate'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
