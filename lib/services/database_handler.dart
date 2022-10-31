import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import "package:mtvdb/helper.dart";

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();

  // String dbPath = join(path, "watch.db");
  // deleteDatabase(dbPath);

  // ByteData data = await rootBundle.load("assets/mtv.db");
  // List<int> bytes =
  //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  // await File(dbPath).writeAsBytes(bytes);
  // return openDatabase(dbPath)

  return openDatabase(
    join(path, 'watch.db'),
    onCreate: (database, version) async {
      await database.execute(
        "CREATE TABLE IF NOT EXISTS watchD(imdbID TEXT PRIMARY KEY, title TEXT NOT NULL, poster TEXT NOT NULL, type TEXT NOT NULL, watchlist TEXT NOT NULL, year TEXT NOT NULL)",
      );
    },
    version: 1,
  );
}

Future<int> insert(Database db, Record rec, bool fw) async {
  String imdbID = rec.imdbID;
  try {
    //database has no entry corresponding to the IMDB ID, either cuz there's no match or its just empty
    await db.insert("watchD", rec.toMap());
    return 0;
  } on DatabaseException {
    // need to check if DB is empty lol
    // if watchlist is true, make it false and show Toast( return -1)
    // if watchlist is false, show Toast( return -2)
    final List<Map<String, Object?>> queryResult =
        await db.query('watchD', where: 'imdbID=?', whereArgs: [imdbID]);

    if (queryResult.isEmpty) {
      //db is empty
      await db.insert("watchD", rec.toMap());
      return 0;
    } else {
      Record rec = queryResult.map((e) => Record.fromMap(e)).toList()[0];

      if (rec.watchlist == "true") {
        if (!fw) {
          Record newrec = Record(
              imdbID: rec.imdbID,
              title: rec.title,
              poster: rec.poster,
              type: rec.type,
              watchlist: "false",
              year: rec.year);
          await db.update("watchD", newrec.toMap(),
              where: "imdbID=?", whereArgs: [newrec.imdbID]);
          return -1;
        } else {
          return -3;
        }
      } else {
        return -2;
      }
    }
  }
}

Future<List<Record>> retrieveAll(Database db) async {
  final List<Map<String, Object?>> queryResult = await db.query('watchD');
  return queryResult.map((e) => Record.fromMap(e)).toList();
}

Future<List<Record>> retrieveData(
    Database db, String type, String watchlist) async {
  debugPrint("starting retrieval");
  final List<Map<String, Object?>> queryResult = await db.query('watchD',
      where: 'type=? AND watchlist=?', whereArgs: [type, watchlist]);
  debugPrint("ending retrieval");
  return queryResult.map((e) => Record.fromMap(e)).toList();
}

void changeWatchlist(Database db, Record rec) async {
  await db.update("watchD", rec.toMap(),
      where: "imdbID= ?", whereArgs: [rec.imdbID]);
}

void delete(Database db, String imdbID) async {
  await db.delete("watchD", where: "imdbId=?", whereArgs: [imdbID]);
}
