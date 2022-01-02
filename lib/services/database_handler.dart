import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import "package:mtvdb/helper.dart";

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();
  // deleteDatabaser(join(path, "mtv.db"));
  return openDatabase(
    join(path, 'mtv.db'),
    onCreate: (database, version) async {
      await database.execute(
        "CREATE TABLE IF NOT EXISTS MTVDB(imdbID TEXT PRIMARY KEY, title TEXT NOT NULL, poster TEXT NOT NULL, type TEXT NOT NULL, watchlist TEXT NOT NULL)",
      );
    },
    version: 1,
  );
}

Future<int> insert(Database db, Record rec, bool fw) async {
  String imdbID = rec.imdbID;
  try {
    await db.insert("MTVDB", rec.toMap());
    return 0;
  } on DatabaseException catch (e) {
    // if watchlist is true, make it false and show Toast( return -1)
    // if watchlist is false, show Toast( return -2)
    final List<Map<String, Object?>> queryResult =
        await db.query('MTVDB', where: 'imdbID=?', whereArgs: [imdbID]);
    Record rec = queryResult.map((e) => Record.fromMap(e)).toList()[0];
    if (rec.watchlist == "true") {
      if (!fw) {
        Record newrec = Record(
            imdbID: rec.imdbID,
            title: rec.title,
            poster: rec.poster,
            type: rec.type,
            watchlist: "false");
        await db.update("MTVDB", newrec.toMap(),
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

Future<List<Record>> retrieveAll(Database db) async {
  final List<Map<String, Object?>> queryResult = await db.query('MTVDB');
  return queryResult.map((e) => Record.fromMap(e)).toList();
}

Future<List<Record>> retrieveData(
    Database db, String type, String watchlist) async {
  debugPrint("starting retrieval");
  final List<Map<String, Object?>> queryResult = await db.query('MTVDB',
      where: 'type=? AND watchlist=?', whereArgs: [type, watchlist]);
  debugPrint("ending retrieval");
  return queryResult.map((e) => Record.fromMap(e)).toList();
}

void changeWatchlist(Database db, Record rec) async {
  await db.update("MTVDB", rec.toMap(),
      where: "imdbID= ?", whereArgs: [rec.imdbID]);
}

void delete(Database db, String imdbID) async {
  await db.delete("MTVDB", where: "imdbId=?", whereArgs: [imdbID]);
}
