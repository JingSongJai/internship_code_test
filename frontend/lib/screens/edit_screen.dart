import 'package:flutter/material.dart';
import 'package:project_crud/models/product_model.dart';
import 'package:project_crud/providers/product_provider.dart';
import 'package:project_crud/widgets/my_button.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final nameTextController = TextEditingController();

  final priceTextController = TextEditingController();

  final stockTextController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProductModel? product;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = ModalRoute.of(context)!.settings.arguments as ProductModel;
    nameTextController.text = product!.productName;
    priceTextController.text = product!.price.toString();
    stockTextController.text = product!.stock.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
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
                label: 'Update Product',
                onPressed: () async {
                  if (formKey.currentState?.validate() != true) return;

                  Map<String, dynamic> data = {
                    'productName': nameTextController.text,
                    'price': priceTextController.text,
                    'stock': stockTextController.text,
                  };

                  await context.read<ProductProvider>().updateProduct(
                    data,
                    product!.id,
                  );

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
