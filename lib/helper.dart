void search(bool? movie, bool? series, bool byIMDb, String searchElement) {
  if (movie != null && series != null) {
    if (movie && series) {
      print("not possible");
    } else if (movie && !series) {
      if (byIMDb) {
        print("[by ID] search for " + searchElement + " which is a movie");
      } else {
        print("[by name] search for " + searchElement + " which is a movie");
      }
    } else if (series && !movie) {
      if (byIMDb) {
        print("[by ID] search for " + searchElement + " which is a series");
      } else {
        print("[by name] search for " + searchElement + " which is a series");
      }
    } else {
      print("You need to search something bro lol");
    }
  }
}
