// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:mtvdb/services/database_handler.dart';
import "helper.dart";
import "details.dart";

class WatchedScreenWidget extends StatefulWidget {
  final List<Record> movies, shows;
  const WatchedScreenWidget(
      {Key? key, required this.movies, required this.shows})
      : super(key: key);

  @override
  _WatchedScreenWidget createState() => _WatchedScreenWidget();
}

class _WatchedScreenWidget extends State<WatchedScreenWidget> {
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
      debugPrint(movie.title);
      if (movie.title.toLowerCase().contains(text.toLowerCase())) {
        debugPrint("checking for $text in ${movie.title}");
        _searchResultM.add(movie);
      }
    }

    for (var show in widget.shows) {
      if (show.title.toLowerCase().contains(text.toLowerCase())) {
        debugPrint("checking for $text in ${show.title}");
        _searchResultS.add(show);
      }
    }

    setState(() {});
  }

  Widget buildMovieList() {
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
                debugPrint(widget.movies[index].imdbID);
                TitleDetails title =
                    await getDetails(widget.movies[index].imdbID);
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
                          const EdgeInsetsDirectional.fromSTEB(5, 30, 5, 30),
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(widget.movies[index].poster)),
                        title: Text(widget.movies[index].title),
                        trailing: IconButton(
                            onPressed: () async {
                              debugPrint(
                                  "delete ${widget.movies[index].imdbID}");
                              delete(await initializeDB(),
                                  widget.movies[index].imdbID);
                              showToast(context,
                                  "Deleted ${widget.movies[index].title} from WatchD!");
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel)),
                      ))));
        });
  }

  Widget buildShowList() {
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
                debugPrint(widget.shows[index].imdbID);
                TitleDetails title =
                    await getDetails(widget.shows[index].imdbID);
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
                        trailing: IconButton(
                            onPressed: () async {
                              debugPrint(
                                  "delete ${widget.shows[index].imdbID}");

                              delete(await initializeDB(),
                                  widget.shows[index].imdbID);
                              showToast(context,
                                  "Deleted ${widget.shows[index].title} from WatchD!");
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel)),
                      ))));
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

  Widget buildSearchListMovie() {
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
                debugPrint(_searchResultM[index].imdbID);
                TitleDetails title =
                    await getDetails(_searchResultM[index].imdbID);
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
                          const EdgeInsetsDirectional.fromSTEB(5, 30, 5, 30),
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(_searchResultM[index].poster)),
                        title: Text(_searchResultM[index].title),
                        trailing: IconButton(
                            onPressed: () async {
                              debugPrint(
                                  "delete ${_searchResultM[index].imdbID}");
                              delete(await initializeDB(),
                                  _searchResultM[index].imdbID);
                              showToast(context,
                                  "Deleted ${_searchResultM[index].title} from WatchD!");
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel)),
                      ))));
        });
  }

  Widget buildSearchListSeries() {
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
                debugPrint(_searchResultS[index].imdbID);
                TitleDetails title =
                    await getDetails(_searchResultS[index].imdbID);
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
                        trailing: IconButton(
                            onPressed: () async {
                              debugPrint(
                                  "delete ${_searchResultS[index].imdbID}");

                              delete(await initializeDB(),
                                  _searchResultS[index].imdbID);
                              showToast(context,
                                  "Deleted ${_searchResultS[index].title} from WatchD!");
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel)),
                      ))));
        });
  }

  @override
  Widget build(BuildContext context) {
    widget.movies.sort((a, b) => a.title.compareTo(b.title));
    widget.shows.sort((a, b) => a.title.compareTo(b.title));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
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
                      text: 'Movies -  ${widget.movies.length}',
                    ),
                    Tab(
                      text: 'Shows - ${widget.shows.length}',
                    ),
                  ],
                ),
                buildSearchBox(),
                Expanded(
                  child: TabBarView(
                    children: [
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5, 30, 5, 30),
                          child: (_searchResultM.isNotEmpty ||
                                  controller.text.isNotEmpty)
                              ? buildSearchListMovie()
                              : buildMovieList()),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 30, 5, 30),
                        child: (_searchResultS.isNotEmpty ||
                                controller.text.isNotEmpty)
                            ? buildSearchListSeries()
                            : buildShowList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
