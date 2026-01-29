import 'package:dio/dio.dart';

import '../../error/failure.dart';

class ApiStatusMapper {
  static Failure map(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 400:
        return NetworkFailure("Bad request");
      case 401:
        return NetworkFailure("Unauthorized");
      case 403:
        return NetworkFailure("Forbidden");
      case 404:
        return NetworkFailure("Not found");
      case 500:
        return NetworkFailure("Server error");
      default:
        return NetworkFailure("Unexpected network error");
    }
  }
}
