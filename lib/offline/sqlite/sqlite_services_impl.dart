import 'package:temp_offline/offline/sqlite/sqlite_service_util.dart';

import '../../models/users_model.dart';
import '../sqlite_models/sqlite_model.dart';
import 'sqlite_db.dart';
import 'sqlite_db_queries.dart';
import 'sqlite_services.dart';

class SqliteServicesImpl extends SqliteServices {
  @override
  Future<int> saveUser(Users data) async {
    await _createTable(Tables.Users.name, DBQueries.createUsers);

    final tableExist = await SqliteDB.tableExist(Tables.Users.name);
    if (!tableExist) {
      /// create table first
      await SqliteDB.executeRawQuery(DBQueries.createUsers);
      /// insert dummy data
      await SqliteDB.executeRawQuery('INSERT INTO Users (name, address) VALUES ("Pasha", "Savar"), ("Zarif", "Gaibandha")');
    }

    var map = SqliteServicesUtil.usersToMap(data);
    int result = await SqliteDB.insertData(Tables.Users.name, map);

    return result;
  }

  @override
  Future<int> updateUser(Users data) async {
    var map = SqliteServicesUtil.usersToMap(data);
    map['oid'] = data.oid;

    int result = await SqliteDB.updateData(Tables.Users.name, map);

    return result;
  }

  @override
  Future<List<Users>> getUsersList() async {
    var responseJson = await SqliteDB.getListBySQL(_getSQL(Tables.Users.name));
    List<Users> dataList = List<Users>.from(responseJson.map((x) => Users.fromJson(x)));

    return dataList;
  }

  _createTable(String tableName, String createScript) async {
    bool tableExist = await SqliteDB.tableExist(tableName);
    if (!tableExist) {
      await SqliteDB.executeRawQuery(createScript);
      print('------------------table created: $tableName');
    }
  }

  String _getSQL(String tableName) {
    var sql = '';
    sql = 'select * from $tableName';

    return sql;
  }
}