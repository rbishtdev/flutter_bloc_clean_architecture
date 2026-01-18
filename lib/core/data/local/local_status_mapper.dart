import 'package:sqflite/sqflite.dart';
import '../../error/failure.dart';

class LocalStatusMapper {
  static Failure map(Object error) {
    if (error is DatabaseException) {
      return DatabaseFailure(error.toString());
    }

    return CacheFailure("Unexpected local storage error");
  }
}
