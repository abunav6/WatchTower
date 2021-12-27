import 'package:flutter/widgets.dart';

void search(bool? movie, bool? series, bool byIMDb, String searchElement) {
  if (movie != null && series != null) {
    if (movie && series) {
      debugPrint("not possible");
    } else if (movie && !series) {
      if (byIMDb) {
        debugPrint("[by ID] search for " + searchElement + " which is a movie");
      } else {
        debugPrint(
            "[by name] search for " + searchElement + " which is a movie");
      }
    } else if (series && !movie) {
      if (byIMDb) {
        debugPrint(
            "[by ID] search for " + searchElement + " which is a series");
      } else {
        debugPrint(
            "[by name] search for " + searchElement + " which is a series");
      }
    } else {
      debugPrint("You need to search something bro lol");
    }
  }
}
