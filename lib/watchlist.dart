// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import "helper.dart";
import "details.dart";
import 'services/database_handler.dart';

class WatchlistWidget extends StatefulWidget {
  final List<Record> movies, shows;
  const WatchlistWidget({Key? key, required this.movies, required this.shows})
      : super(key: key);

  @override
  _WatchlistWidget createState() => _WatchlistWidget();
}

class _WatchlistWidget extends State<WatchlistWidget> {
  final List<Record> _searchResultM = [], _searchResultS = [];

  TextEditingController controller = TextEditingController();

  onSearchTextChanged(String text) async {
    _searchResultM.clear();
    _searchResultS.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var movie in widget.movies) {
      if (movie.title
          .toLowerCase()
          .trim()
          .contains(text.toLowerCase().trim())) {
        _searchResultM.add(movie);
      }
    }

    for (var show in widget.shows) {
      if (show.title.toLowerCase().trim().contains(text.toLowerCase().trim())) {
        _searchResultS.add(show);
      }
    }

    setState(() {});
  }

  Widget buildMovieWatchlist() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: widget.movies.length,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                TitleDetails title =
                    await getDetails(widget.movies[index].imdbID);

                setState(() {
                  isLoading = false;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreenWidget(
                            title: title,
                            showButtons: false,
                          )),
                );
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(5, 30, 5, 40),
                      child: ListTile(
                          leading: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(widget.movies[index].poster)),
                          title: Text(widget.movies[index].title),
                          subtitle: Text(widget.movies[index].year),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () async {
                                      debugPrint(
                                          "watched ${widget.movies[index].title}!");

                                      fChangeWatchlist(widget.movies[index]);
                                      showToast(context,
                                          "Added ${widget.movies[index].title} to WatchTower!");
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check)),
                                IconButton(
                                    onPressed: () async {
                                      debugPrint("delete from watchlist");

                                      fDelete(widget.movies[index].imdbID);
                                      showToast(context,
                                          "Deleted ${widget.movies[index].title} from your watchlist!");
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.cancel))
                              ])))));
        });
  }

  Widget buildShowWatchlist() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: widget.shows.length,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                TitleDetails title =
                    await getDetails(widget.shows[index].imdbID);

                setState(() {
                  isLoading = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreenWidget(
                          title: title, showButtons: false)),
                );
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(5, 30, 5, 30),
                      child: ListTile(
                          leading: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(widget.shows[index].poster)),
                          title: Text(widget.shows[index].title),
                          subtitle: Text(widget.shows[index].year),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () async {
                                      debugPrint(
                                          "watched ${widget.shows[index].title}!");

                                      fChangeWatchlist(widget.shows[index]);

                                      showToast(context,
                                          "Added ${widget.shows[index].title} to WatchTower!");
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check)),
                                IconButton(
                                    onPressed: () async {
                                      debugPrint("delete from watchlist");

                                      fDelete(widget.shows[index].imdbID);
                                      showToast(context,
                                          "Deleted ${widget.shows[index].title} from your watchlist!");
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.cancel))
                              ])))));
        });
  }

  Widget buildSearchBox() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: ListTile(
            leading: const Icon(Icons.search),
            title: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  hintText: 'Search', border: InputBorder.none),
              onChanged: onSearchTextChanged,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                controller.clear();
                onSearchTextChanged('');
              },
            ),
          ),
        ));
  }

  Widget buildWLSearchMovies() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: _searchResultM.length,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                TitleDetails title =
                    await getDetails(_searchResultM[index].imdbID);

                setState(() {
                  isLoading = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreenWidget(
                            title: title,
                            showButtons: false,
                          )),
                );
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(5, 30, 5, 40),
                      child: ListTile(
                          leading: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(_searchResultM[index].poster)),
                          title: Text(_searchResultM[index].title),
                          subtitle: Text(_searchResultM[index].year),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () async {
                                      debugPrint(
                                          "watched ${_searchResultM[index].title}!");
                                      fChangeWatchlist(_searchResultM[index]);
                                      showToast(context,
                                          "Added ${_searchResultM[index].title} to WatchTower!");
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check)),
                                IconButton(
                                    onPressed: () async {
                                      debugPrint("delete from watchlist");

                                      fDelete(_searchResultM[index].imdbID);
                                      showToast(context,
                                          "Deleted ${_searchResultM[index].title} from your watchlist!");
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.cancel))
                              ])))));
        });
  }

  Widget buildWLSearchShows() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: _searchResultS.length,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                TitleDetails title =
                    await getDetails(_searchResultS[index].imdbID);
                setState(() {
                  isLoading = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreenWidget(
                          title: title, showButtons: false)),
                );
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(5, 30, 5, 30),
                      child: ListTile(
                          leading: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(_searchResultS[index].poster)),
                          title: Text(_searchResultS[index].title),
                          subtitle: Text(_searchResultS[index].year),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () async {
                                      debugPrint(
                                          "watched ${_searchResultS[index].title}!");
                                      fChangeWatchlist(_searchResultS[index]);
                                      showToast(context,
                                          "Added ${_searchResultS[index].title} to WatchTower!");
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check)),
                                IconButton(
                                    onPressed: () async {
                                      debugPrint("delete from watchlist");

                                      fDelete(_searchResultS[index].imdbID);
                                      showToast(context,
                                          "Deleted ${_searchResultS[index].title} from your watchlist!");
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.cancel))
                              ])))));
        });
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    widget.movies.sort((a, b) => a.title.compareTo(b.title));
    widget.shows.sort((a, b) => a.title.compareTo(b.title));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              children: [
                TabBar(
                  labelColor: Colors.white,
                  indicatorColor: const Color(0xFF673AB7),
                  tabs: [
                    Tab(
                      text: 'Movies - ${widget.movies.length}',
                    ),
                    Tab(
                      text: 'Shows - ${widget.shows.length}',
                    ),
                  ],
                ),
                buildSearchBox(),
                Expanded(
                    child: Stack(children: [
                  Opacity(
                    opacity: isLoading ? 0.5 : 1,
                    child: TabBarView(
                      children: [
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5, 30, 5, 30),
                            child: (_searchResultM.isNotEmpty ||
                                    controller.text.isNotEmpty)
                                ? buildWLSearchMovies()
                                : buildMovieWatchlist()),
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5, 30, 5, 30),
                            child: (_searchResultS.isNotEmpty ||
                                    controller.text.isNotEmpty)
                                ? buildWLSearchShows()
                                : buildShowWatchlist()),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black)),
                    )
                ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
