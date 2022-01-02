import 'package:flutter/material.dart';
import "helper.dart";
import "details.dart";
import "services/DatabaseHandler.dart";

class WatchlistWidget extends StatelessWidget {
  final List<Record> movies, shows;
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
                  indicatorColor: const Color(0xFF673AB7),
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
                                      TitleDetails title = await getDetails(
                                          movies[index].imdbID);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsScreenWidget(
                                                  title: title,
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
                                                .fromSTEB(5, 30, 5, 40),
                                            child: ListTile(
                                                leading: CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            movies[index]
                                                                .poster)),
                                                title:
                                                    Text(movies[index].title),
                                                trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      IconButton(
                                                          onPressed: () async {
                                                            debugPrint(
                                                                "watched ${movies[index].title}!");
                                                            Record rec = Record(
                                                                imdbID: movies[
                                                                        index]
                                                                    .imdbID,
                                                                title: movies[
                                                                        index]
                                                                    .title,
                                                                poster: movies[
                                                                        index]
                                                                    .poster,
                                                                type: movies[
                                                                        index]
                                                                    .type,
                                                                watchlist:
                                                                    "false");
                                                            changeWatchlist(
                                                                await initializeDB(),
                                                                rec);
                                                            showToast(context,
                                                                "Added ${movies[index].title} to WatchD!");
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                              Icons.check)),
                                                      IconButton(
                                                          onPressed: () async {
                                                            debugPrint(
                                                                "delete from watchlist");
                                                            delete(
                                                                await initializeDB(),
                                                                movies[index]
                                                                    .imdbID);
                                                            showToast(context,
                                                                "Deleted ${movies[index].title} from your watchlist!");
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                              Icons.cancel))
                                                    ])))));
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
                                      TitleDetails title =
                                          await getDetails(shows[index].imdbID);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsScreenWidget(
                                                    title: title,
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
                                                    backgroundImage:
                                                        NetworkImage(
                                                            shows[index]
                                                                .poster)),
                                                title: Text(shows[index].title),
                                                trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      IconButton(
                                                          onPressed: () async {
                                                            debugPrint(
                                                                "watched ${shows[index].title}!");
                                                            Record rec = Record(
                                                                imdbID:
                                                                    shows[index]
                                                                        .imdbID,
                                                                title:
                                                                    shows[index]
                                                                        .title,
                                                                poster:
                                                                    shows[index]
                                                                        .poster,
                                                                type:
                                                                    shows[index]
                                                                        .type,
                                                                watchlist:
                                                                    "false");
                                                            changeWatchlist(
                                                                await initializeDB(),
                                                                rec);
                                                            showToast(context,
                                                                "Added ${shows[index].title} to WatchD!");
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                              Icons.check)),
                                                      IconButton(
                                                          onPressed: () async {
                                                            debugPrint(
                                                                "delete from watchlist");
                                                            delete(
                                                                await initializeDB(),
                                                                shows[index]
                                                                    .imdbID);
                                                            showToast(context,
                                                                "Deleted ${shows[index].title} from your watchlist!");
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                              Icons.cancel))
                                                    ])))));
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
