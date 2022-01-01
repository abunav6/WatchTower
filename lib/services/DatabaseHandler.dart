import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import "package:mtvdb/helper.dart";

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    //deleteDatabase(join(path, "watchd.db"));
    return openDatabase(
      join(path, 'watchd.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE IF NOT EXISTS watchd(imdbID TEXT PRIMARY KEY, type TEXT NOT NULL, watchlist TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insert(Record rec) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert("watchd", rec.toMap());
    return result;
  }

  Future<List<Record>> retrieveAll() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('watchd');
    return queryResult.map((e) => Record.fromMap(e)).toList();
  }

  Future<List<Record>> retrieveData(String type, String watchlist) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('watchd',
        where: 'type=? AND watchlist=?', whereArgs: [type, watchlist]);
    return queryResult.map((e) => Record.fromMap(e)).toList();
  }

  void changeWatchlist(Record rec) async {
    final Database db = await initializeDB();
    await db.update("watchd", rec.toMap(),
        where: "imdbID= ?", whereArgs: [rec.imdbID]);
  }

  void delete(String imdbID) async {
    final Database db = await initializeDB();
    await db.delete("watchd", where: "imdbId=?", whereArgs: [imdbID]);
  }
}
