import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../../models/Product.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    this.pressOnSeeMore,
  }) : super(key: key);

  final GestureTapCallback? pressOnSeeMore;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Price",
              border: OutlineInputBorder(),
            ),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

      ],
    );
  }
}
