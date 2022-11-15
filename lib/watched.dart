// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mtvdb/services/database_handler.dart';
import 'package:mtvdb/stats.dart';
import 'package:sqflite/sqflite.dart';
import "helper.dart";
import "details.dart";

class WatchedScreenWidget extends StatefulWidget {
  final List<Record> movies;

  final List<Record> shows;

  final bool fromStats;

  const WatchedScreenWidget(
      {Key? key,
      required this.movies,
      required this.shows,
      required this.fromStats})
      : super(key: key);

  @override
  _WatchedScreenWidget createState() => _WatchedScreenWidget();
}

class _WatchedScreenWidget extends State<WatchedScreenWidget> {
  final List<Record> _searchResultM = [], _searchResultS = [];
  TextEditingController controller = TextEditingController();
  ScrollController listScrollController = ScrollController();

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

  Widget buildMovieList() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 10,
          );
        },
        controller: listScrollController,
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
                        subtitle: Text(widget.movies[index].year),
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
        controller: listScrollController,
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
                        subtitle: Text(widget.shows[index].year),
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
        controller: listScrollController,
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
                        subtitle: Text(_searchResultM[index].year),
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
        controller: listScrollController,
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
                        subtitle: Text(_searchResultS[index].year),
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

  void handleClick(int item) async {
    switch (item) {
      case 0:
        final Database db = await initializeDB();

        List<Map<String, Object?>> directorData = await db.rawQuery(
            "select director, count('director') as c from watchD where watchlist='false' AND type='movie' group by director order by count('director') desc limit 10;");

        List<Map<String, Object?>> runtimeData = await db.rawQuery(
            "select sum(runtime) as sum from watchD where watchlist='false' AND type='movie' AND runtime!='';");

        List<Map<String, Object?>> imdbRatingData = await db.rawQuery(
            "select avg(imdbRating) as avg from watchD where watchlist='false' AND type='movie' AND imdbRating!='';");

        List<Map<String, Object?>> maxrun = await db.rawQuery(
            "select imdbID from watchD where watchlist='false' AND type='movie' AND runtime!='' order by cast(runtime as int) desc limit 1;");

        List<Map<String, Object?>> minrun = await db.rawQuery(
            "select imdbID from watchD where watchlist='false' AND type='movie' AND runtime!='' order by cast(runtime as int) asc limit 1;");

        String maxi = maxrun.elementAt(0)['imdbID'].toString();
        TitleDetails max = await getDetails(maxi);

        String mini = minrun.elementAt(0)['imdbID'].toString();
        TitleDetails min = await getDetails(mini);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StatsWidget(
                    dd: directorData,
                    rd: runtimeData,
                    max: max,
                    min: min,
                    id: imdbRatingData)));
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.movies.sort((a, b) => a.title.compareTo(b.title));
    if (widget.shows.isNotEmpty) {
      widget.shows.sort((a, b) => a.title.compareTo(b.title));
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF673AB7),
                child: IconButton(
                    icon: const Icon(Icons.arrow_upward_rounded,
                        color: Colors.white),
                    onPressed: () {
                      listScrollController.animateTo(0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut);
                    })),
            onPressed: () {}),
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: !widget.fromStats
              ? <Widget>[
                  PopupMenuButton<int>(
                    onSelected: (item) => handleClick(item),
                    itemBuilder: (context) => [
                      const PopupMenuItem<int>(
                          value: 0, child: Text('View Stats')),
                    ],
                  ),
                ]
              : [],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
            child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(children: [
                  !widget.fromStats
                      ? TabBar(
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
                        )
                      : Container(),
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
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5, 30, 5, 30),
                          child: !widget.fromStats
                              ? ((_searchResultS.isNotEmpty ||
                                      controller.text.isNotEmpty)
                                  ? buildSearchListSeries()
                                  : buildShowList())
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                ])),
          ),
        ));
  }
}
