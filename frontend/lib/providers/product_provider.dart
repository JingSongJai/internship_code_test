import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_crud/services/product_service.dart';
import 'package:project_crud/models/product_model.dart';
import 'package:project_crud/utils/helper.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool isLoading = false, isLoadingMore = false, hasMore = true;
  int currentPage = 1;
  Timer? timer;
  String _sort = 'ID', _order = 'ASC';
  final textController = TextEditingController();

  List<ProductModel> get products => _products;

  String get sort => _sort;

  String get order => _order;

  set setSort(String sort) {
    _sort = sort;
    notifyListeners();
  }

  set setOrder(String order) {
    _order = order;
    notifyListeners();
  }

  Future<void> getProducts() async {
    hasMore = true;
    isLoading = true;
    notifyListeners();

    currentPage = 1;
    _products = await ProductService().getProducts(
      name: textController.text,
      sort: _sort,
      order: _order,
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreProducts(context) async {
    if (isLoadingMore || !hasMore) return;
    log(currentPage.toString());

    isLoadingMore = true;
    notifyListeners();

    var moreProducts = await ProductService().getProducts(
      page: currentPage + 1,
      sort: _sort,
      order: _order,
      name: textController.text,
    );

    if (moreProducts.isEmpty) {
      hasMore = false;
      Helper.showSnackBar(context, 'No more products!');
    } else {
      currentPage++;
      _products.addAll(moreProducts);
    }

    isLoadingMore = false;
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    isLoading = true;
    notifyListeners();

    var isDeleted = await ProductService().deleteProduct(id);

    if (isDeleted) _products.removeWhere((product) => product.id == id);

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProduct(Map<String, dynamic> data, int id) async {
    isLoading = true;
    notifyListeners();

    var isUpdated = await ProductService().updateProduct(data, id);

    if (isUpdated) {
      int index = _products.indexWhere((product) => product.id == id);
      data['id'] = id;
      _products[index] = ProductModel.fromJson(data);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Map<String, dynamic> data) async {
    hasMore = true;
    isLoading = true;
    notifyListeners();

    var newProduct = await ProductService().addProduct(data);

    if (newProduct != null) {
      log('Here');
      _products.add(newProduct);
    }

    isLoading = false;
    notifyListeners();
  }

  void deboucerSearch(String name) {
    timer?.cancel();

    timer = Timer(const Duration(seconds: 2), () async => await getProducts());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
