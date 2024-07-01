import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';
import '../../models/Product.dart';
import '../cart/cart_screen.dart';
import 'components/SmallProductImage.dart';
import 'components/color_dots.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';

class CreateSellCard extends StatelessWidget {
  const CreateSellCard({Key? key}) : super(key: key);
  static String routeName = "/CreateSellCard";

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
          ProductImages(),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(
                  pressOnSeeMore: () {},
                ),

              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(3.0),
        child: BottomAppBar(
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
                      },
                      child: const Text("AI"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

