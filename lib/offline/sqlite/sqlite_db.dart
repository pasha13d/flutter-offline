import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:stack_trace/stack_trace.dart';
import '../../utility/constants.dart';
import '../sqlite_models/sqlite_model.dart';

class SqliteDB {
  static String? get _dbname => 'offline.db';
  static int? get _version => 2;

  static final SqliteDB _instance = new SqliteDB.internal();

  factory SqliteDB() => _instance;

  static Database? _database;

  static Future<Database?> get _db async {
    var lineNo = Trace.current().frames[1].line;
    var clazzName = Trace.current().frames[1].member!.split('.')[0];
    var methodName = Trace.current().frames[1].member!.split('.')[1];
    var msg = 'This method called from ' + methodName + ' method of ' + clazzName + ' class, line number ' + lineNo.toString();
    print('############ $msg #############');

    if (_database != null) {
      print('>>>>>>>>>>>>>>>>>>>>>>>> DATABASE NOT NULL <<<<<<<<<<<<<<<<<<<<<<<<<<<');
      return _database;
    } else {
      print('>>>>>>>>>>>>>>>>>>>>>>>> DATABASE NULL <<<<<<<<<<<<<<<<<<<<<<<<<<<');
      _database = await _initDb();
      return _database;
    }
  }

  SqliteDB.internal();

  /// Initialize DB
  static _initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, _dbname);

    var taskDb;
    try {
      var isExist = await databaseExists(path);
      if (!isExist) {
        taskDb = await openDatabase(path, version: _version, onCreate: _onCreate);
        print('>>>>>>>>>>>>>>>>>>>>>>>> new db initiated <<<<<<<<<<<<<<<<<<<<<<<<<<<');
      } else {
        taskDb = await openDatabase(path, version: _version);
        print('>>>>>>>>>>>>>>>>>>>>>>>> connect with db <<<<<<<<<<<<<<<<<<<<<<<<<<<');
      }
    } catch (ex) {
      print(ex);
    }
    return taskDb;
  }

  static Future<SqliteUpdateStatus> CreateLocalDB() async {
    print('>>>>>>>>>>>>>>>>>>>>>>>> inside CreateLocalDB() <<<<<<<<<<<<<<<<<<<<<<<<<<<');
    SqliteUpdateStatus status = SqliteUpdateStatus();

    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, _dbname);

    try {
      var dbExist = await databaseExists(path);
      print('>>>>>>>>>>>>>>>>>>>>>>>> inside CreateLocalDB(), dbExist: $dbExist,  _database: ${jsonEncode(_database)} <<<<<<<<<<<<<<<<<<<<<<<<<<<');
      if (dbExist == false) {
        _database = await openDatabase(path, version: _version, onCreate: _onCreateFirstTime);
        status.isSuccess = true;
        status.message = Constants.msgDBConInitiated;
        print('>>>>>>>>>>>>>>>>>>>>>>>> new db initiated <<<<<<<<<<<<<<<<<<<<<<<<<<<');
      } else {
        _database = await openDatabase(path, version: _version);
        status.isSuccess = true;
        status.message = Constants.msgDBConExist;
        print('>>>>>>>>>>>>>>>>>>>>>>>> connect with db <<<<<<<<<<<<<<<<<<<<<<<<<<<');
      }
    } catch (e) {
      print(e.toString());
      status.isSuccess = false;
      status.message = e.toString();
    }
    // await Offline.API!.configureDBTables();
    return status;
  }

  static void _onCreateFirstTime(Database db, int version) async {
    /// Added DB tables that you want to create instantly after creating local DB
    print('_onCreateFirstTime function called.....................');
  }

  static Future<SqliteUpdateStatus> configSqliteDB() async {
    SqliteUpdateStatus status = SqliteUpdateStatus();

    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, _dbname);

    try {
      var dbExist = await databaseExists(path);
      if (dbExist) {
        status.isSuccess = true;
        status.message = Constants.msgDBConExist;
        return status;
      } else {
        await openDatabase(path, version: _version, onCreate: _onCreate);
        status.isSuccess = true;
        status.message = Constants.msgDBConInitiated;
        print('>>>>>>>>>>>>>>>>>>>>>>>> new db initiated <<<<<<<<<<<<<<<<<<<<<<<<<<<');
        return status;
      }
    } catch (e) {
      print(e.toString());
      status.isSuccess = false;
      status.message = e.toString();
      return status;
    }
  }

  static void _onCreate(Database db, int version) async {
    bool tableExist = await SqliteDB.tableExist("product_categories");
    if(!tableExist) {
      await db.execute('CREATE TABLE product_categories (id INTEGER PRIMARY KEY AUTOINCREMENT, categoryName STRING)');
      await db.execute("INSERT INTO product_categories (categoryName) VALUES ('T-Shirt'), ('Shirt'), ('Trouser'),  ('Shoes');");
      print('_onCreate function called.....................');
    }
  }

  /// Count number of tables in DB
  static Future countTable() async {
    var dbClient = await _db;
    var res = await dbClient!.rawQuery("""SELECT count(*) as count FROM sqlite_master
         WHERE type = 'table'
         AND name != 'android_metadata'
         AND name != 'sqlite_sequence';""");
    return res[0]['count'];
  }

  static Future<SqliteUpdateStatus> deleteDB(String path) async {
    SqliteUpdateStatus status = SqliteUpdateStatus();
    var databasesPath = await getDatabasesPath();
    path = p.join(databasesPath, _dbname);
    try {
      _database = null;
      deleteDatabase(path);
      status.isSuccess = true;
      status.message = 'Database deleted successfully';
      print('########## Local database deleted successfully');
    } catch (e) {
      print(e.toString());
      status.message = e.toString();
    }
    return status;
  }
  //=========================

  // to execute raw query
  static Future<dynamic> executeRawQuery(String sql) async {
    try {
      var dbClient = await _db;
      var res = await dbClient!.rawQuery(sql);
      return res;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // to check table exist or not, returns true/false
  static Future<bool> tableExist(String tableName) async {
    bool exist = false;
    try {
      var sql = "SELECT COUNT(*) as val FROM sqlite_master WHERE type='table' AND name='$tableName'";
      var res = await executeRawQuery(sql);
      if (res[0]["val"] == 1) exist = true;
    } catch (e) {
      print(e.toString());
    }
    return exist;
  }

  static Future<bool> columnExist(String tableName, String columnName) async {
    var sql = "SELECT * FROM pragma_table_info('$tableName') where name = '$columnName' ";
    var result = await SqliteDB.executeRawQuery(sql);
    var columnExist = false;
    for (var x in result) {
      if (x["name"] == columnName) {
        columnExist = true;
        break;
      }
    }
    return columnExist;
  }

  static String getMsg(Trace trace, String method) {
    var lineNo = trace.frames[1].line;
    var clazzName = trace.frames[1].member!.split('.')[0];
    var methodName = trace.frames[1].member!.split('.')[1];
    var msg = '$method method/function called from ' + methodName + ' method of ' + clazzName + ' class, line number ' + lineNo.toString();
    print('############ $msg #############');
    return msg;
  }

  // get all from a table by table name
  static Future<List<Map<String, dynamic>>> getAllByTableName(String tableName) async {
    //String sss = getMsg(Trace.current(), 'getAllByTableName');

    List<Map<String, dynamic>> map = [];
    try {
      var dbClient = await _db;
      map = await dbClient!.query(tableName);
    } catch (e) {
      print(e.toString());
    }
    return map;
  }

  static Future<List<Map<String, dynamic>>> getListBySQL(String sql) async {
    List<Map<String, dynamic>> map = [];
    try {
      var dbClient = await _db;
      map = await dbClient!.rawQuery(sql);
    } catch (e) {
      print(e.toString());
    }
    return map;
  }

  static Future<int> insertData(String tableName, Map<String, dynamic> mapObj) async {
    int result = 0;
    try {
      var dbClient = await _db;
      result = await dbClient!.insert(tableName, mapObj, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  static Future<int> deleteAll(String tableName) async {
    int result = 0;
    try {
      var dbClient = await _db;
      result = await dbClient!.delete(tableName);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  static Future<int> deleteData(String tableName, {String? where, List<dynamic>? whereArgs}) async {
    int result = 0;
    try {
      var dbClient = await _db;
      result = await dbClient!.delete(tableName, where: where, whereArgs: whereArgs);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  static Future<int> updateData(String tableName, Map<String, dynamic> mapObj) async {
    int result = 0;
    try {
      var dbClient = await _db;

      int oid = mapObj['oid'];
      result = await dbClient!.update(tableName, mapObj, where: 'oid = ?', whereArgs: [oid]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }
}

