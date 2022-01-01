import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "helper.dart";
import "details.dart";
import "services/DatabaseHandler.dart";

class WatchlistWidget extends StatelessWidget {
  final List<TitleDetails> movies, shows;
  const WatchlistWidget({Key? key, required this.movies, required this.shows})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    movies.sort((a, b) => a.title.compareTo(b.title));
    shows.sort((a, b) => a.title.compareTo(b.title));
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
                  indicatorColor: Color(0xFF673AB7),
                  tabs: [
                    Tab(
                      text: 'Movies - ${movies.length}',
                    ),
                    Tab(
                      text: 'Shows - ${shows.length}',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5, 30, 5, 30),
                          child: ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: movies.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () async {
                                      debugPrint(movies[index].imdbID);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsScreenWidget(
                                                  title: movies[index],
                                                  showButtons: false,
                                                )),
                                      );
                                    },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5, 30, 5, 30),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                      movies[index].poster)),
                                              title: Text(movies[index].title),
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    debugPrint(
                                                        "watched ${movies[index].title}!");
                                                    Record rec = Record(
                                                        imdbID: movies[index]
                                                            .imdbID,
                                                        type:
                                                            movies[index].type,
                                                        watchlist: "false");
                                                    DatabaseHandler()
                                                        .changeWatchlist(rec);
                                                    showToast(context,
                                                        "Added ${movies[index].title} to WatchD!");
                                                    Navigator.pop(context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.check)),
                                            ))));
                              })),
                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5, 30, 5, 30),
                          child: ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: shows.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () async {
                                      debugPrint(shows[index].imdbID);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsScreenWidget(
                                                    title: shows[index],
                                                    showButtons: false)),
                                      );
                                    },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5, 30, 5, 30),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                      shows[index].poster)),
                                              title: Text(shows[index].title),
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    debugPrint(
                                                        "watched ${shows[index].title}");
                                                    Record rec = Record(
                                                        imdbID:
                                                            shows[index].imdbID,
                                                        type: shows[index].type,
                                                        watchlist: "false");
                                                    DatabaseHandler()
                                                        .changeWatchlist(rec);
                                                    showToast(context,
                                                        "Added ${shows[index].title} to WatchD!");
                                                    Navigator.pop(context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.check)),
                                            ))));
                              })),
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
