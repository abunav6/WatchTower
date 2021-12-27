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

Future<void> search(
// TODO: Need to get the JSON object using decode() and then pass it to the options screen, where the processing can be done to extract the list of titles

    bool? movie,
    bool? series,
    bool byIMDb,
    String searchElement) async {
  if (movie != null && series != null) {
    String url_base = "http://www.omdbapi.com/?apikey=b9fb2464&";
    searchElement.trim();
    searchElement = searchElement.replaceAll(" ", "%20");
    if (movie && series) {
      debugPrint("not possible");
    } else if (movie && !series) {
      if (byIMDb) {
        String parsed =
            await http.read(Uri.parse(url_base + "i=" + searchElement));
        debugPrint(parsed);
      } else {
        String parsed = await http
            .read(Uri.parse(url_base + "s=" + searchElement + "&type=movie"));
        debugPrint(parsed);
      }
    } else if (series && !movie) {
      if (byIMDb) {
        debugPrint(url_base + "i=" + searchElement);
      } else {
        debugPrint(url_base + "s=" + searchElement + "&type=series");
      }
    } else {
      debugPrint("You need to search something bro lol");
    }
  }
}
