import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['Year'] = this.year;
    data['imdbID'] = this.imdbID;
    data['Poster'] = this.poster;
    return data;
  }
}

List<SearchDetails> getTitleLists(final data) {
  List<SearchDetails> details = [];

  final jsonData = json.decode(data);
  if (jsonData["Response"] == "True") {
    List<dynamic> searchEle = jsonData["Search"];
    for (int i = 0; i < searchEle.length; i++) {
      if (searchEle[i] != null) {
        Map<String, dynamic> temp = searchEle[i];
        details.add(SearchDetails.fromJson(searchEle[i]));
      }
    }
    return details;
  } else {
    debugPrint(jsonData["Error"]);
    return [];
  }
}

Future<void> search(
    bool? movie, bool? series, bool byIMDb, String searchElement) async {
  if (movie != null && series != null) {
    String url_base = "http://www.omdbapi.com/?apikey=b9fb2464&";
    final titleData;
    searchElement.trim();
    searchElement = searchElement.replaceAll(" ", "%20");
    if (movie && series) {
      debugPrint("not possible");
    } else if (movie && !series) {
      if (byIMDb) {
        titleData = await http.read(Uri.parse(url_base + "i=" + searchElement));
      } else {
        titleData = await http
            .read(Uri.parse(url_base + "s=" + searchElement + "&type=movie"));
      }

      List<SearchDetails> options = getTitleLists(titleData);
    } else if (series && !movie) {
      if (byIMDb) {
        titleData = await http.read(Uri.parse(url_base + "i=" + searchElement));
      } else {
        titleData = await http
            .read(Uri.parse(url_base + "s=" + searchElement + "&type=series"));
      }
      debugPrint(titleData);
      List<SearchDetails> options = getTitleLists(titleData);
    } else {
      debugPrint("You need to search something bro lol");
    }
  }
}
