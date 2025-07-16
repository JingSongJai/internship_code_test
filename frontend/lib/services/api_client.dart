import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000'));
}
