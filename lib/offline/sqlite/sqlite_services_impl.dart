import '../../models/users_model.dart';
import '../sqlite_models/sqlite_model.dart';
import 'sqlite_db.dart';
import 'sqlite_db_queries.dart';
import 'sqlite_services.dart';

class SqliteServicesImpl extends SqliteServices {
  @override
  Future<List<Users>> saveUser() async {
    await _createTable(Tables.Users.name, DBQueries.createUsers);

    bool tableExist = await SqliteDB.tableExist(Tables.Users.name);
    if (!tableExist) {
      /// create table first
      await SqliteDB.executeRawQuery(DBQueries.createUsers);
      /// insert dummy data
      await SqliteDB.executeRawQuery('INSERT INTO Users (name, address) VALUES ("Pasha", "Savar"), ("Zarif", "Gaibandha")');
    }

    var responseJson = await SqliteDB.getAllByTableName(Tables.Users.name);
    List<Users> usersList = List<Users>.from(responseJson.map((x) => Users.fromJson(x)));

    return usersList;
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