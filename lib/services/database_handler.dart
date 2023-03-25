import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import "package:mtvdb/helper.dart";
import 'dart:convert';

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();

  // String dbPath = join(path, "watch.db");
  // deleteDatabase(dbPath);

  // ByteData data = await rootBundle.load("assets/watch.db");
  // List<int> bytes =
  //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  // await File(dbPath).writeAsBytes(bytes);
  // return openDatabase(dbPath);

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

Future<int> fInsert(Record toAdd, bool fromWatchlist) async {
  // 1. check if imdbID exists in DB
  // 2. if exists -> check if coming fromWatchlist page. If yes, change watchlist to "false". else, return code to show attempted duplicate insert
  // 3. if not exists -> add to DB
  DatabaseEvent snap = await FirebaseDatabase.instance.ref().once();

  Map<dynamic, dynamic> nodes = snap.snapshot.value as Map;
  for (var key in nodes.keys) {
    Record r = Record.fromMap(json.decode(jsonEncode(nodes[key])));
    if (r.imdbID == toAdd.imdbID) {
      //exists in the DB, need to check if it's in watchlist or not
      if (r.watchlist == "true") {
        // exists in the watchlist, need to check if we are coming from the wachlist page or not
        if (!fromWatchlist) {
          // coming from the search page
          // toggle watchlist var, delete from DB, add to DB
          debugPrint("Need to toggle rec's watchlist to false and update DB");
          FirebaseDatabase.instance
              .ref()
              .child("/$key")
              .update({"watchlist": "false"});

          return -1;
        } else {
          debugPrint(
              "Already exists in watchlist, trying to add to watchlist!");
          return -3;
        }
      } else {
        debugPrint("Already exists in WatchD list");
        return -2;
      }
    }
  }
  FirebaseDatabase.instance.ref().push().set(toAdd.toMap());
  return 0;
}

// Future<int> insert(Database db, Record rec, bool fromWatchlist) async {
//   String imdbID = rec.imdbID;
//   debugPrint(rec.toMap().toString());
//   try {
//     //database has no entry corresponding to the IMDB ID, either cuz there's no match or its just empty
//     await db.insert("watchD", rec.toMap());
//     return 0;
//   } on DatabaseException {
//     // need to check if DB is empty                                       -->> if table is empty
//     // if watchlist is true, make it false and show Toast( return -1)     -->> if exists in watchlist, move to watchD
//     // if watchlist is false, show Toast( return -2)                      -->> if aleady exists in WatchD
//     final List<Map<String, Object?>> queryResult =
//         await db.query('watchD', where: 'imdbID=?', whereArgs: [imdbID]);

//     if (queryResult.isEmpty) {
//       // DB doesn't contain the IMDB ID, or, is empty
//       await db.insert("watchD", rec.toMap());
//       return 0;
//     } else {
//       Record rec = queryResult.map((e) => Record.fromMap(e)).toList()[0];

//       if (rec.watchlist == "true") {
//         if (!fromWatchlist) {
//           // coming from the WatchD page
//           Record newrec = Record(
//               imdbID: rec.imdbID,
//               title: rec.title,
//               poster: rec.poster,
//               type: rec.type,
//               watchlist: "false",
//               year: rec.year,
//               director: rec.director,
//               imdbRating: rec.imdbRating,
//               runtime: rec.runtime);
//           await db.update("watchD", newrec.toMap(),
//               where: "imdbID=?", whereArgs: [newrec.imdbID]);
//           return -1;
//         } else {
//           return -3;
//         }
//       } else {
//         return -2;
//       }
//     }
//   }
// }

// Future<List<Record>> retrieveAll(Database db) async {
//   final List<Map<String, Object?>> queryResult = await db.query('watchD');
//   return queryResult.map((e) => Record.fromMap(e)).toList();
// }

Future<List<Record>> fRetrieveAll() async {
  DatabaseEvent snap = await FirebaseDatabase.instance.ref().once();

  List nodes = snap.snapshot.value as List;

  List<Record> allTitles = [];
  for (Object node in nodes) {
    Map<String, dynamic> tmp = json.decode(jsonEncode(node));
    allTitles.add(Record.fromMap(tmp));
  }
  return allTitles;
}

// Future<List<Record>> retrieveData(
//     Database db, String type, String watchlist) async {
//   debugPrint("starting retrieval");
//   final List<Map<String, Object?>> queryResult = await db.query('watchD',
//       where: 'type=? AND watchlist=?', whereArgs: [type, watchlist]);
//   debugPrint("ending retrieval");
//   return queryResult.map((e) => Record.fromMap(e)).toList();
// }

Future<List<Record>> fRetrieveData(String type, String watchlistValue) async {
  DatabaseEvent snap = await FirebaseDatabase.instance.ref().once();
  Map<dynamic, dynamic> nodes = snap.snapshot.value as Map;

  List<Record> records = [];
  nodes.forEach((key, value) {
    Record r = Record.fromMap(json.decode(jsonEncode(value)));
    if (r.type == type && r.watchlist == watchlistValue) {
      records.add(r);
    }
  });

  return records;
}

void changeWatchlist(Database db, Record rec) async {
  if (rec.type == 'series') {
    await db.update("watchD", rec.toMap(),
        where: "imdbID= ?", whereArgs: [rec.imdbID]);
  } else {
    await db.update("watchD", rec.toMap(),
        where: "imdbID= ?", whereArgs: [rec.imdbID]);
  }
}

void fChangeWatchlist(Record rec) async {
  DatabaseEvent snap = await FirebaseDatabase.instance.ref().once();

  Map<dynamic, dynamic> nodes = snap.snapshot.value as Map;
  for (var key in nodes.keys) {
    Record r = Record.fromMap(json.decode(jsonEncode(nodes[key])));
    if (r.imdbID == rec.imdbID) {
      FirebaseDatabase.instance
          .ref()
          .child("/$key")
          .update({"watchlist": "false"});
    }
  }
}

void delete(Database db, String imdbID) async {
  await db.delete("watchD", where: "imdbId=?", whereArgs: [imdbID]);
}

void fDelete(String imdbID) async {
  debugPrint("here");
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  DatabaseEvent snap = await ref.once();
  Map<dynamic, dynamic> map = snap.snapshot.value as Map;

  debugPrint("need to delete");

  map.forEach((key, value) {
    Record r = Record.fromMap(json.decode(jsonEncode(value)));
    if (r.imdbID == imdbID) {
      ref.child("/$key").remove();
    }
  });
}
