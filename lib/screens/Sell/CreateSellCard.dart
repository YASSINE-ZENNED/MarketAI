import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../models/Product.dart';
import '../cart/cart_screen.dart';
import '../products/products_screen.dart';
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
  late TextEditingController _titleController ;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  TextEditingController keywordsController = TextEditingController();
  int selectedImage = 0;
  List<XFile> _pickedImages = [];
  bool _isNew = false;


  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _pickedImages = pickedFiles;
        selectedImage = 0;  // Reset to the first image
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    keywordsController.dispose();
    _priceController.dispose();
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
          _pickedImages.isEmpty
              ? SizedBox(
            width: 150,
            child: AspectRatio(
              aspectRatio: 2              ,
              child: Placeholder(),
            ),
          )
              : SizedBox(
            width: 150,
            child: AspectRatio(
              aspectRatio: 2,
              child: Image.file(File(_pickedImages[selectedImage].path)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                _pickedImages.length,
                    (index) => SmallProductImage(
                  isSelected: index == selectedImage,
                  press: () {
                    setState(() {
                      selectedImage = index;
                    });
                  },
                  imageFile: File(_pickedImages[index].path),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Product Title",
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Product Description",
                    ),
                    maxLines:5,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _priceController,

                          decoration: InputDecoration(
                            labelText: "Price",
                          ),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SwitchListTile(
                          title: Text("New" ,             style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12),                           ),
                          value: _isNew,
                          onChanged: (bool value) {
                            setState(() {
                              _isNew = value;
                            });
                          },
                        ),
                      ),
                    ],
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
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: ElevatedButton(
                    onPressed: () {
                      _postProductForSale();
                    },
                    child: const Text("Post product for sale"),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ElevatedButton(
                    onPressed: () {
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
    demoProducts.add( Product(
      id: 20,
      images: _pickedImages.map((image) => image.path).toList(),
      colors: [
        const Color(0xFFF6625E),
        const Color(0xFF836DB8),
        const Color(0xFFDECB9C),
        Colors.white,
      ],
      title: _titleController.text,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,

    ));
    Navigator.pushNamed(context, ProductsScreen.routeName);
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
                      Navigator.of(context).pop();
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
                  onPressed: () async {
                    // Prepare data to send
                    String apiUrl = 'https://eff9-165-51-95-20.ngrok-free.app/DescribeForClient';

                    try {
                      // Create multipart request for uploading images
                      var request = http.MultipartRequest('GET', Uri.parse(apiUrl));

                      // Add images
                      for (var image in _pickedImages) {
                        request.files.add(await http.MultipartFile.fromPath('image', image.path));
                      }

                      // Add keywords as a field
                      request.fields['keywords'] = keywordsController.text.trim();

                      // Send the request
                      var response = await request.send();

                      // Check the response status
                      if (response.statusCode == 200) {
                        var responseBody = await response.stream.bytesToString();
                        print('API Response: $responseBody');
                        List<String> lines = responseBody.split('\n');

                        // Extract the first line
                        String firstLine = lines.first;

                        // Join the remaining lines (excluding the first)
                        String rest = lines.skip(1).join('\n');

                        print("API Response - First line: $firstLine");
                        print("API Response - Rest: $rest");

                        setState(() {
                          _titleController.text = firstLine;
                          _descriptionController.text = rest;
                        });
                        // Handle API response
                      } else {
                        print('Failed to send data. Status code: ${response.statusCode}');
                      }
                    } catch (e) {
                      print('Error sending data: $e');
                    }
                    Navigator.of(context).pop();
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
