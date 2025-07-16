import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_crud/models/product_model.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Helper {
  Helper._();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Future<bool> _permissionHandler(BuildContext context) async {
    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return true;
    } else {
      if (context.mounted) showSnackBar(context, 'Storage permission denied');
      return false;
    }
  }

  static Future<String> _getSavePath(String fileName) async {
    final dir = await getExternalStorageDirectory();
    final path = '${dir!.path}/$fileName';
    return path;
  }

  static Future<void> exportToPDF(
    List<ProductModel> products,
    BuildContext context,
  ) async {
    bool isGranted = await _permissionHandler(context);

    if (!isGranted) return;

    final document = PdfDocument();
    final page = document.pages.add();

    final grid = PdfGrid();
    grid.columns.add(count: 4);
    grid.headers.add(1);
    final header = grid.headers[0].cells;
    header[0].value = 'ID';
    header[1].value = 'Name';
    header[2].value = 'Price';
    header[3].value = 'Stock';

    for (final p in products) {
      final row = grid.rows.add();
      row.cells[0].value = p.id.toString();
      row.cells[1].value = p.productName;
      row.cells[2].value = p.price.toString();
      row.cells[3].value = p.stock.toString();
    }

    grid.draw(page: page, bounds: const Rect.fromLTWH(0, 0, 500, 800));

    final path = await _getSavePath('products.pdf');
    final file = File(path);
    await file.writeAsBytes(await document.save());
    if (context.mounted) showSnackBar(context, 'File have been saved to $path');
    document.dispose();
  }
}
