import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_crud/providers/product_provider.dart';
import 'package:project_crud/widgets/my_button.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameTextController = TextEditingController();

  final priceTextController = TextEditingController();

  final stockTextController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 10,
            children: [
              TextFormField(
                controller: nameTextController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product Name required!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceTextController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price required!';
                  } else if (double.tryParse(value) == null) {
                    return 'Price must be number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: stockTextController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stock required!';
                  } else if (int.tryParse(value) == null) {
                    return 'Stock must be number';
                  }
                  return null;
                },
              ),
              MyButton(
                label: 'Add Product',
                onPressed: () async {
                  if (formKey.currentState?.validate() != true) return;

                  var data = {
                    'productName': nameTextController.text,
                    'price': priceTextController.text,
                    'stock': stockTextController.text,
                  };

                  await context.read<ProductProvider>().addProduct(data);

                  if (context.mounted) Navigator.pop(context);
                },
                color: Colors.blue,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
