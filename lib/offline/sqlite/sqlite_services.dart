import '../../models/users_model.dart';

abstract class SqliteServices {
  Future<List<Users>> saveUser();
  Future<List<Users>> getUsersList();
}