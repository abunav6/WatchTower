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

Future<int> insert(Database db, Record rec) async {
  int result = 0;
  result = await db.insert("MTVDB", rec.toMap());
  return result;
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
