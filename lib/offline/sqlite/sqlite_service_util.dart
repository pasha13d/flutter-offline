import 'package:temp_offline/models/users_model.dart';

class SqliteServicesUtil {
  static Map<String, dynamic> usersToMap(Users data) {
    var map = {
      "name": data.name,
      "address": data.address,
    };
    return map;
  }
}