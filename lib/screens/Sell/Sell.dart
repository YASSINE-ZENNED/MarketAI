import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picker

class CreateItemScreen extends StatefulWidget {
  static String routeName = "/create-item";

  const CreateItemScreen({super.key});

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";
  double _price = 0.0; // You can add a price field if needed
  XFile? _imageFile; // To store the selected image

  // Function to launch image picker
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _imageFile = pickedImage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Item"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Image selection area
              _imageFile != null
                  ? Image.file(File(_imageFile!.path)) // Display selected image
                  : ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Choose Image"),
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title for your item.";
                  }
                  return null;
                },
                onSaved: (newValue) => _title = newValue!,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Description",
                  hintText: "Tell buyers about your item!",
                ),
                maxLines: null, // Allows multiline input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please describe your item.";
                  }
                  return null;
                },
                onSaved: (newValue) => _description = newValue!,
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _imageFile != null) {
                    _formKey.currentState!.save();
                    // TODO: Implement logic to save item information including image
                    // This might involve sending data and image to a backend server.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Item created successfully!")),
                    );
                    Navigator.pop(context); // Close the screen
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select an image and fill out all fields!")),
                    );
                  }
                },
                child: const Text("Create Item"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
