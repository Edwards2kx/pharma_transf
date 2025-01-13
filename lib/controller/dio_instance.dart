import 'package:dio/dio.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';

class DioInstance {
  static final DioInstance _singleton = DioInstance._internal();
  late Dio dio;

  factory DioInstance() {
    return _singleton;
  }

  DioInstance._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://147.93.35.156/APP/app_services.php',
    ));
    dio.interceptors.add(PrettyDioLogger(
      queryParameters: true,
      requestBody: false,
      responseHeader: false,
      responseBody: true,
      canShowLog: true
    ));
  }

  static Dio getDio() {
    return _singleton.dio;
  }
}
