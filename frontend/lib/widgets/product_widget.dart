import 'package:flutter/material.dart';
import 'package:project_crud/models/product_model.dart';
import 'package:project_crud/providers/product_provider.dart';
import 'package:project_crud/screens/edit_screen.dart';
import 'package:project_crud/widgets/my_button.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product.id} - ${product.productName}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text('Price : ${product.price}'),
                    Text('Stock : ${product.stock}'),
                  ],
                ),
              ),
              Column(
                children: [
                  MyButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: 'Edit',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditScreen(),
                          settings: RouteSettings(arguments: product),
                        ),
                      );
                    },
                    color: Colors.green,
                  ),
                  MyButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    label: 'Delete',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => _buildConfirmDialog(context),
                      );
                    },
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Do you want to delete this product?'),
      content: const Text('It can\'t be undone!'),
      actions: [
        MyButton(
          color: Colors.grey.shade400,
          label: 'Cancel',
          onPressed: () {
            Navigator.pop(context);
          },
          width: double.infinity,
        ),
        MyButton(
          color: Colors.blue,
          label: 'Confirm',
          onPressed: () async {
            await context.read<ProductProvider>().deleteProduct(product.id);

            if (context.mounted) Navigator.pop(context);
          },
          width: double.infinity,
        ),
      ],
    );
  }
}
