import 'package:flutter/material.dart';
import 'package:mtvdb/services/DatabaseHandler.dart';
import "helper.dart";
import "details.dart";

class WatchedScreenWidget extends StatelessWidget {
  final List<TitleDetails> movies, shows;

  const WatchedScreenWidget(
      {Key? key, required this.movies, required this.shows})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    movies.sort((a, b) => a.title.compareTo(b.title));
    shows.sort((a, b) => a.title.compareTo(b.title));

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
                      text: 'Movies -  ${movies.length}',
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
                                                  onPressed: () async {
                                                    debugPrint(
                                                        "delete ${movies[index].imdbID}");
                                                    delete(await initializeDB(),
                                                        movies[index].imdbID);
                                                    showToast(context,
                                                        "Deleted ${movies[index].title} from WatchD!");
                                                    Navigator.pop(context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.cancel)),
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
                                                  onPressed: () async {
                                                    debugPrint(
                                                        "delete ${shows[index].imdbID}");

                                                    delete(await initializeDB(),
                                                        shows[index].imdbID);
                                                    showToast(context,
                                                        "Deleted ${shows[index].title} from WatchD!");
                                                    Navigator.pop(context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.cancel)),
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
