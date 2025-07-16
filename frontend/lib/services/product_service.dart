import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project_crud/models/product_model.dart';
import 'package:project_crud/services/api_client.dart';

class ProductService {
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int perPage = 10,
    String name = '',
    String order = '',
    String sort = '',
  }) async {
    List<ProductModel> products = [];
    try {
      var response = await ApiClient.dio.get(
        '/product?page=$page&per_page=$perPage&name=$name&order=$order&sort=$sort',
      );

      if (response.statusCode == 200) {
        products =
            (response.data['data'] as List)
                .map((product) => ProductModel.fromJson(product))
                .toList();
      }
    } on DioException catch (err) {
      debugPrint('Dio Error : ${err.message}');
    } catch (err) {
      debugPrint('Error : $err');
    }

    return products;
  }

  Future<ProductModel?> getProduct(int id) async {
    try {
      var response = await ApiClient.dio.get('/product');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data['data']);
      }
    } on DioException catch (err) {
      debugPrint('Dio Error : ${err.message}');
    } catch (err) {
      debugPrint('Error : $err');
    }

    return null;
  }

  Future<bool> deleteProduct(int id) async {
    try {
      var response = await ApiClient.dio.delete('/product/$id');

      if (response.statusCode == 200) return true;
    } on DioException catch (err) {
      debugPrint('Dio Error : ${err.message}');
    } catch (err) {
      debugPrint('Error : $err');
    }
    return false;
  }

  Future<ProductModel?> addProduct(Map<String, dynamic> data) async {
    try {
      var response = await ApiClient.dio.post('/product', data: data);

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data['data']);
      }
    } on DioException catch (err) {
      debugPrint('Dio Error : ${err.message}');
    } catch (err) {
      debugPrint('Error : $err');
    }
    return null;
  }

  Future<bool> updateProduct(Map<String, dynamic> data, int id) async {
    try {
      var response = await ApiClient.dio.put('/product/$id', data: data);

      if (response.statusCode == 200) return true;
    } on DioException catch (err) {
      debugPrint('Dio Error : ${err.message}');
    } catch (err) {
      debugPrint('Error : $err');
    }
    return false;
  }
}
