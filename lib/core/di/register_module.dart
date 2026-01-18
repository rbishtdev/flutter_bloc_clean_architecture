import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../data/remote/dio_provider.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio dio(DioClient client) => client.create();

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
