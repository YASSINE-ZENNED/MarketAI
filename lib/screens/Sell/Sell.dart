import 'package:flutter/material.dart';

class SellItemScreen extends StatefulWidget {
  const SellItemScreen({Key? key}) : super(key: key);
  static String routeName = "/sell";

  @override
  State<SellItemScreen> createState() => _SellItemScreenState();
}

class _SellItemScreenState extends State<SellItemScreen> {
  final _formKey = GlobalKey<FormState>();
  static String routeName = "/sell";

  String _title = "";
  String _description = "";
  double _price = 0.0;
  bool _isNew = false; // Checkbox for new/used item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sell Your Item"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Price",
                  prefixText: "\$", // Add currency symbol
                ),
                keyboardType: TextInputType.number, // For numeric input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a price.";
                  }
                  return null;
                },
                onSaved: (newValue) => _price = double.parse(newValue!),
              ),
              Row(
                children: [
                  Text("New"),
                  Checkbox(
                    value: _isNew,
                    onChanged: (value) => setState(() => _isNew = value!),
                  ),
                  const Text("Used"),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // TODO: Implement logic to save item information to marketplace
                    // This might involve sending data to a backend server.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Item listing saved!")),
                    );
                    Navigator.pop(context); // Close the screen
                  }
                },
                child: const Text("Sell Item"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
