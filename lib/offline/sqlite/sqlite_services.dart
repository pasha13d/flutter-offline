import '../../models/users_model.dart';

abstract class SqliteServices {
  Future<int> saveUser(Users data);
  Future<int> updateUser(Users data);
  Future<List<Users>> getUsersList();
}