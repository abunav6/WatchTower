// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Record {
  String imdbID = "";
  String type = "";
  String watchlist = "";

  Record({required this.imdbID, required this.type, required this.watchlist});

  Record.fromMap(Map<String, dynamic> res)
      : imdbID = res["imdbID"],
        type = res["type"],
        watchlist = res["watchlist"];

  Map<String, Object> toMap() {
    return {"imdbID": imdbID, "type": type, "watchlist": watchlist};
  }
}

void showToast(BuildContext context, String s) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(s),
      action:
          SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

Future<TitleDetails> getDetails(String imdbID) async {
  String url = "http://www.omdbapi.com/?apikey=b9fb2464&i=" + imdbID;
  final response = await http.read(Uri.parse(url));
  // debugPrint(response);
  final jsonData = json.decode(response);
  return TitleDetails.fromJson(jsonData);
}

class TitleDetails {
  String title = "";
  String year = "";
  String runtime = "";
  String genre = "";
  String poster = "";
  List<Ratings> ratings = [];
  String imdbID = "";
  String type = "";

  TitleDetails({
    required this.title,
    required this.year,
    required this.runtime,
    required this.genre,
    required this.poster,
    required this.ratings,
    required this.imdbID,
    required this.type,
  });

  TitleDetails.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    year = json['Year'];
    runtime = json['Runtime'];
    genre = json['Genre'];
    poster = json['Poster'];
    if (json['Ratings'] != null) {
      json['Ratings'].forEach((v) {
        ratings.add(Ratings.fromJson(v));
      });
    }
    imdbID = json['imdbID'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Title'] = this.title;
    data['Year'] = this.year;
    data['Runtime'] = this.runtime;
    data['Genre'] = this.genre;

    data['Poster'] = this.poster;

    data['Ratings'] = this.ratings.map((v) => v.toJson()).toList();

    data['imdbID'] = this.imdbID;
    data['Type'] = this.type;
    return data;
  }
}

class Ratings {
  String source = "";
  String value = "";

  Ratings({required this.source, required this.value});

  Ratings.fromJson(Map<String, dynamic> json) {
    source = json['Source'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Source'] = this.source;
    data['Value'] = this.value;
    return data;
  }
}

class SearchDetails {
  String title = "";
  String year = "";
  String imdbID = "";
  String poster = "";

  SearchDetails(
      {required this.title,
      required this.year,
      required this.imdbID,
      required this.poster});

  SearchDetails.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    year = json['Year'];
    imdbID = json['imdbID'];
    poster = json['Poster'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Title'] = this.title;
    data['Year'] = this.year;
    data['imdbID'] = this.imdbID;
    data['Poster'] = this.poster;
    return data;
  }
}

List<SearchDetails> getSearchList(final data) {
  List<SearchDetails> details = [];

  final jsonData = json.decode(data);
  if (jsonData["Response"] == "True") {
    List<dynamic> searchEle = jsonData["Search"];
    for (int i = 0; i < searchEle.length; i++) {
      if (searchEle[i] != null) {
        Map<String, dynamic> temp = searchEle[i];
        if (temp["Poster"] == "N/A") {
          Map<String, dynamic> temp2 = <String, dynamic>{};
          temp2["Title"] = temp["Title"];
          temp2["Poster"] =
              "https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1811/pavelstasevich181101028/112815904-no-image-available-icon-flat-vector-illustration.jpg?ver=6";
          temp2["Year"] = temp["Year"];
          temp2["imdbID"] = temp["imdbID"];
          details.add(SearchDetails.fromJson(temp2));
        } else {
          details.add(SearchDetails.fromJson(temp));
        }
      }
    }
    return details;
  } else {
    debugPrint(jsonData["Error"]);
    return [];
  }
}

Future<List<SearchDetails>> search(
    bool? movie, bool? series, bool byIMDb, String searchElement) async {
  if (movie != null && series != null) {
    String urlBase = "http://www.omdbapi.com/?apikey=b9fb2464&";
    final String titleData;
    searchElement.trim();
    searchElement = searchElement.replaceAll(" ", "%20");
    if (movie && series) {
      debugPrint("not possible");
      return [];
    } else if (movie && !series) {
      if (byIMDb) {
        titleData = await http.read(Uri.parse(urlBase + "i=" + searchElement));
      } else {
        titleData = await http
            .read(Uri.parse(urlBase + "s=" + searchElement + "&type=movie"));
      }

      return getSearchList(titleData);
    } else if (series && !movie) {
      if (byIMDb) {
        titleData = await http.read(Uri.parse(urlBase + "i=" + searchElement));
      } else {
        titleData = await http
            .read(Uri.parse(urlBase + "s=" + searchElement + "&type=series"));
      }
      return getSearchList(titleData);
    } else {
      debugPrint("You need to search something bro lol");
      return [];
    }
  } else {
    return [];
  }
}

Future<List<TitleDetails>> getList(List<Record> rec) async {
  List<TitleDetails> result = [];
  for (int i = 0; i < rec.length; i++) {
    TitleDetails temp = await getDetails(rec[i].imdbID);
    result.add(temp);
  }
  return result;
}
