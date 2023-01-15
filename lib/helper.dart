// ignore_for_file: unnecessary_this, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mtvdb/person_helper.dart';
import 'dart:convert';
import 'package:mtvdb/secrets.dart';

class Record {
  String imdbID = "";
  String title = "";
  String poster = "";
  String type = "";
  String watchlist = "";
  String year = "";
  String? director = "";
  String? runtime = '';
  String? imdbRating = '';

  Record(
      {required this.imdbID,
      required this.title,
      required this.poster,
      required this.type,
      required this.watchlist,
      required this.year,
      required this.director,
      required this.runtime,
      required this.imdbRating});

  Record.fromMap(Map<String, dynamic> res)
      : imdbID = res["imdbID"],
        title = res["title"],
        poster = res["poster"],
        type = res["type"],
        watchlist = res["watchlist"],
        year = res["year"],
        director = res["director"],
        runtime = res["runtime"],
        imdbRating = res["imdbRating"];

  Map<String, Object> toMap() {
    if (runtime == "N/A") {
      runtime = "";
    }
    if (imdbRating == "N/A") {
      imdbRating = "";
    }
    debugPrint({
      "imdbID": imdbID,
      "title": title,
      "poster": poster,
      "type": type,
      "watchlist": watchlist,
      "year": year,
      "director": director as String,
      "runtime": runtime as String,
      "imdbRating": imdbRating as String
    }.toString());
    return {
      "imdbID": imdbID,
      "title": title,
      "poster": poster,
      "type": type,
      "watchlist": watchlist,
      "year": year,
      "director": director as String,
      "runtime": runtime as String,
      "imdbRating": imdbRating as String
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

Future<int> getPersonID(String name) async {
  String searchPersonByString =
      "https://api.themoviedb.org/3/search/person?api_key=$tmdb&language=en-US&query=${Uri.encodeComponent(name)}&page=1&include_adult=false";

  var response = await http.read(Uri.parse(searchPersonByString));
  var jsonData = json.decode(response);
  Person p = Person.fromJson(jsonData);
  int personID = p.results![0].id as int;

  return personID;
}

Future<String> getPersonImage(String name) async {
  int personID = await getPersonID(name);

  return "https://api.themoviedb.org/3/person/$personID/images?api_key=$tmdb";
}

Future<String> getDirectorImageURL(String name) async {
  // replace with TMDb API call, this is not at all needed
  // Use search person by string API from TMDB, get person ID, and then get Image URL Path

  String pURL = await getPersonImage(name);

  String imagePathBase = "https://image.tmdb.org/t/p/original";

  final response = await http.read(Uri.parse(pURL));
  String url = imagePathBase +
      ImageSearch.fromJson(json.decode(response))
          .profiles!
          .elementAt(0)
          .filePath
          .toString();
  if (url.isEmpty) {
    return "";
  } else {
    return url;
  }
}

Future<TitleDetails> getDetails(String imdbID) async {
  String url = "http://www.omdbapi.com/?apikey=$omdb&i=$imdbID";
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

Future<TitleDetails> searchByID(String imdbID) async {
  imdbID.toLowerCase().trim();
  String url = "http://www.omdbapi.com/?apikey=$omdb&i=$imdbID";

  final String titleData = await http.read(Uri.parse(url));
  final jsonData = json.decode(titleData);
  return TitleDetails.fromJson(jsonData);
}

Future<List<SearchDetails>> searchByName(
    bool? movie, bool? series, String searchElement) async {
  if (movie != null && series != null) {
    String urlBase = "http://www.omdbapi.com/?apikey=$omdb&";
    final String titleData;
    searchElement.trim();
    searchElement = searchElement.replaceAll(" ", "%20");
    if (movie && series) {
      debugPrint("not possible");
      return [];
    } else if (movie && !series) {
      titleData =
          await http.read(Uri.parse("${urlBase}s=$searchElement&type=movie"));
      return getSearchList(titleData);
    } else if (series && !movie) {
      titleData =
          await http.read(Uri.parse("${urlBase}s=$searchElement&type=series"));

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

class Credits {
  List<Cast>? cast;
  List<Crew>? crew;
  int? id;

  Credits({this.cast, this.crew, this.id});

  Credits.fromJson(Map<String, dynamic> json) {
    if (json['cast'] != null) {
      cast = <Cast>[];
      json['cast'].forEach((v) {
        cast!.add(new Cast.fromJson(v));
      });
    }
    if (json['crew'] != null) {
      crew = <Crew>[];
      json['crew'].forEach((v) {
        crew!.add(new Crew.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cast != null) {
      data['cast'] = this.cast!.map((v) => v.toJson()).toList();
    }
    if (this.crew != null) {
      data['crew'] = this.crew!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class Cast {
  int? id;
  double? popularity;
  String? posterPath;
  String? title;
  String? releaseDate;

  Cast({
    this.id,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
  });

  Cast.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    popularity = json['popularity'];
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];

    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;

    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    data['release_date'] = this.releaseDate;

    data['title'] = this.title;
    return data;
  }
}

class Crew {
  int? id;

  double? popularity;
  String? posterPath;
  String? releaseDate;

  String? title;

  Crew({
    this.id,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
  });

  Crew.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    posterPath = json['poster_path'];
    popularity = json['popularity'];
    releaseDate = json['release_date'];

    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;

    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    data['release_date'] = this.releaseDate;

    data['title'] = this.title;

    return data;
  }
}

Future<dynamic> getMovieCredits(int personID) async {
  String url =
      "https://api.themoviedb.org/3/person/$personID/movie_credits?api_key=$tmdb&language=en-US";
  final String credits = await http.read(Uri.parse(url));
  final jsonData = json.decode(credits);
  return Credits.fromJson(jsonData);
}

class IMDBIDGetter {
  int? id;
  String? imdbId;

  IMDBIDGetter({
    this.id,
    this.imdbId,
  });

  IMDBIDGetter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imdbId = json['imdb_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imdb_id'] = this.imdbId;

    return data;
  }
}

Future<String> getIMDBID(int tmdbID) async {
  String url =
      "https://api.themoviedb.org/3/movie/$tmdbID/external_ids?api_key=$tmdb";
  final String credits = await http.read(Uri.parse(url));
  final jsonData = json.decode(credits);
  return IMDBIDGetter.fromJson(jsonData).imdbId as String;
}
