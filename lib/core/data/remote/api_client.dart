import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'api_status_mapper.dart';

@LazySingleton()
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<T> get<T>(
      String apiEndPoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        T Function(dynamic data)? parser,
      }) {
    return _request<T>(
          () => _dio.get(
        apiEndPoint,
        queryParameters: queryParameters,
        options: options,
      ),
      parser,
    );
  }

  Future<T> post<T>(
      String apiEndPoint, {
        dynamic body,
        Map<String, dynamic>? queryParameters,
        Options? options,
        T Function(dynamic data)? parser,
      }) {
    return _request<T>(
          () => _dio.post(
        apiEndPoint,
        data: body,
        queryParameters: queryParameters,
        options: options,
      ),
      parser,
    );
  }

  Future<T> patch<T>(
      String apiEndPoint, {
        dynamic body,
        Map<String, dynamic>? queryParameters,
        Options? options,
        T Function(dynamic data)? parser,
      }) {
    return _request<T>(
          () => _dio.patch(
        apiEndPoint,
        data: body,
        queryParameters: queryParameters,
        options: options,
      ),
      parser,
    );
  }

  Future<T> delete<T>(
      String apiEndPoint, {
        dynamic body,
        Map<String, dynamic>? queryParameters,
        Options? options,
        T Function(dynamic data)? parser,
      }) {
    return _request<T>(
          () => _dio.delete(
        apiEndPoint,
        data: body,
        queryParameters: queryParameters,
        options: options,
      ),
      parser,
    );
  }


  Future<T> _request<T>(
      Future<Response> Function() request,
      T Function(dynamic data)? parser,
      ) async {
    try {
      final response = await request();
      final data = response.data;
      return parser != null ? parser(data) : data as T;
    } on DioException catch (e) {
      throw ApiStatusMapper.map(e);
    }
  }
}
