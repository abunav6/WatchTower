// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Record {
  String imdbID = "";
  String title = "";
  String poster = "";
  String type = "";
  String watchlist = "";
  String year = "";

  Record(
      {required this.imdbID,
      required this.title,
      required this.poster,
      required this.type,
      required this.watchlist,
      required this.year});

  Record.fromMap(Map<String, dynamic> res)
      : imdbID = res["imdbID"],
        title = res["title"],
        poster = res["poster"],
        type = res["type"],
        watchlist = res["watchlist"],
        year = res["year"];

  Map<String, Object> toMap() {
    return {
      "imdbID": imdbID,
      "title": title,
      "poster": poster,
      "type": type,
      "watchlist": watchlist,
      "year": year
    };
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
  String director = "";
  String writer = "";
  String actors = "";
  String plot = "";
  String poster = "";
  List<Ratings> ratings = [];
  String imdbID = "";
  String type = "";

  TitleDetails(
      {required this.title,
      required this.year,
      required this.runtime,
      required this.genre,
      required this.director,
      required this.writer,
      required this.actors,
      required this.plot,
      required this.poster,
      required this.ratings,
      required this.imdbID,
      required this.type});

  TitleDetails.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    year = json['Year'];
    runtime = json['Runtime'];
    genre = json['Genre'];
    director = json['Director'];
    writer = json['Writer'];
    poster = json["Poster"];
    actors = json['Actors'];
    plot = json['Plot'];
    if (json['Ratings'] != null) {
      ratings = <Ratings>[];
      json['Ratings'].forEach((v) {
        ratings.add(new Ratings.fromJson(v));
      });
    }
    imdbID = json['imdbID'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['Year'] = this.year;
    data['Runtime'] = this.runtime;
    data['Genre'] = this.genre;
    data['Director'] = this.director;
    data['Writer'] = this.writer;
    data['Actors'] = this.actors;
    data['Plot'] = this.plot;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

Future<TitleDetails> searchByID(String imdbID) async {
  imdbID.toLowerCase().trim();
  String url = "http://www.omdbapi.com/?apikey=b9fb2464&i=$imdbID";

  final String titleData = await http.read(Uri.parse(url));
  final jsonData = json.decode(titleData);
  return TitleDetails.fromJson(jsonData);
}

Future<List<SearchDetails>> searchByName(
    bool? movie, bool? series, String searchElement) async {
  if (movie != null && series != null) {
    String urlBase = "http://www.omdbapi.com/?apikey=b9fb2464&";
    final String titleData;
    searchElement.trim();
    searchElement = searchElement.replaceAll(" ", "%20");
    if (movie && series) {
      debugPrint("not possible");
      return [];
    } else if (movie && !series) {
      titleData = await http
          .read(Uri.parse(urlBase + "s=" + searchElement + "&type=movie"));
      return getSearchList(titleData);
    } else if (series && !movie) {
      titleData = await http
          .read(Uri.parse(urlBase + "s=" + searchElement + "&type=series"));

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
  //This is the time consuming element of the application

  List<TitleDetails> result = [];
  for (int i = 0; i < rec.length; i++) {
    TitleDetails temp = await getDetails(rec[i].imdbID);
    result.add(temp);
  }
  return result;
}
