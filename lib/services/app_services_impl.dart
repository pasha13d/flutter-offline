import 'package:temp_offline/models/users_model.dart';
import '../offline/sqlite/sqlite_offline_api.dart';
import 'app_services.dart';

class AppServicesImpl extends AppServices {
  @override
  Future<int> saveUser(Users data) async {
    int result;
    result = await Offline.API!.saveUser(data);

    return result;
  }

  @override
  Future<int> updateUser(Users data) async {
    int result;
    result = await Offline.API!.updateUser(data);

    return result;
  }

  @override
  Future<List<Users>> getUsersList() async {
    List<Users> dataList = [];
    dataList = await Offline.API!.getUsersList();

    return dataList;
  }
}