abstract class DBQueries {
  static String get createUsers {
    return """
    CREATE TABLE IF NOT EXISTS Users (
      oid INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NULL,
      address TEXT NULL
    ) """;
  }
}