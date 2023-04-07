import 'dart:async';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import "package:mtvdb/helper.dart";
import 'dart:convert';

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

Future<List<Record>> getMoviesbyDirector(String directorName) async {
  DatabaseEvent snap = await FirebaseDatabase.instance.ref().once();
  Map<dynamic, dynamic> nodes = snap.snapshot.value as Map;

  List<Record> records = [];
  nodes.forEach((key, value) {
    Record r = Record.fromMap(json.decode(jsonEncode(value)));
    if (r.director == directorName &&
        r.type == "movie" &&
        r.watchlist == "false") {
      records.add(r);
    }
  });

  return records;
}

Future<String> getAverageRating() async {
  DatabaseEvent snap = await FirebaseDatabase.instance.ref().once();
  Map<dynamic, dynamic> nodes = snap.snapshot.value as Map;

  double sum = 0.0;
  int count = 0;
  nodes.forEach((key, value) {
    Record r = Record.fromMap(json.decode(jsonEncode(value)));
    if (r.watchlist == "false" && r.type == "movie" && r.imdbRating != '') {
      try {
        sum += double.parse(r.imdbRating as String);
        count += 1;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  });
  double average = sum / count;
  return average.toStringAsFixed(2);
}

Future<List<String>> getRuntimeData() async {
  DatabaseEvent snap = await FirebaseDatabase.instance.ref().once();
  Map<dynamic, dynamic> nodes = snap.snapshot.value as Map;

  int sum = 0;
  int max = -1;
  int min = 10000;

  String maxIMDBId = '', minIMDBId = '';

  nodes.forEach((key, value) {
    Record r = Record.fromMap(json.decode(jsonEncode(value)));
    if (r.watchlist == "false" && r.type == "movie" && r.runtime != '') {
      try {
        int x;
        try {
          x = int.parse(r.runtime as String);
        } catch (e) {
          x = int.parse((r.runtime as String).split("min")[0].trim());
        }
        if (x > max) {
          max = x;
          maxIMDBId = r.imdbID;
        } else if (x < min) {
          min = x;
          minIMDBId = r.imdbID;
        }

        sum += x;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  });
  return [sum.toString(), maxIMDBId, minIMDBId];
}

Future<Map<String, int>> getTopTenDirectors() async {
  DatabaseEvent snap = await FirebaseDatabase.instance.ref().once();
  Map<dynamic, dynamic> nodes = snap.snapshot.value as Map;

  Map<String, int> ttd = {};

  nodes.forEach((key, value) {
    Record r = Record.fromMap(json.decode(jsonEncode(value)));
    if (r.watchlist == "false" && r.type == "movie") {
      try {
        ttd[r.director as String] = ttd[r.director as String]! + 1;
      } catch (e) {
        ttd[r.director as String] = 1;
      }
    }
  });
  var mapEntries = ttd.entries.toList()
    ..sort((b, a) => a.value.compareTo(b.value));
  ttd
    ..clear()
    ..addEntries(mapEntries.sublist(0, 10));
  return ttd;
}

Future<Map<String, int>> getyearMap() async {
  Map<String, int> yearMap = {};

  DatabaseEvent snap = await FirebaseDatabase.instance.ref().once();
  Map<dynamic, dynamic> nodes = snap.snapshot.value as Map;
  nodes.forEach((key, value) {
    Record r = Record.fromMap(json.decode(jsonEncode(value)));
    if (r.type == "movie" && r.watchlist == "false") {
      try {
        yearMap[r.year] = yearMap[r.year]! + 1;
      } catch (e) {
        yearMap[r.year] = 1;
      }
    }
  });

  return yearMap;
}

Future<List<String>> getMoviesFromThisYear(String year) async {
  List<String> imdbIDS = [];

  DatabaseEvent snap = await FirebaseDatabase.instance.ref().once();
  Map<dynamic, dynamic> nodes = snap.snapshot.value as Map;
  nodes.forEach((key, value) {
    Record r = Record.fromMap(json.decode(jsonEncode(value)));
    if (r.type == "movie" && r.watchlist == "false") {
      if (r.year == year) {
        imdbIDS.add(r.imdbID);
      }
    }
  });

  return imdbIDS;
}
