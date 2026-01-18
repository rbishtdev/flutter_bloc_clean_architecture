import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../utils/constant.dart';


@lazySingleton
class DioClient {
  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(LogInterceptor());

    return dio;
  }
}

