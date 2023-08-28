import 'package:temp_offline/models/users_model.dart';

abstract class AppServices {
  Future<int> saveUser(Users data);
  Future<int> updateUser(Users data);
  Future<List<Users>> getUsersList();
}