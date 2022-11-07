// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtvdb/services/database_handler.dart';
import 'package:mtvdb/watched.dart';
import 'package:sqflite/sqflite.dart';

import 'helper.dart';

class DirectorsScreenWidget extends StatefulWidget {
  final List<Map<String, Object?>> directors;
  const DirectorsScreenWidget({Key? key, required this.directors})
      : super(key: key);

  @override
  _DirectorsScreenWidget createState() => _DirectorsScreenWidget();
}

class _DirectorsScreenWidget extends State<DirectorsScreenWidget> {
  ScrollController listScrollController = ScrollController();

  void navigateToWatchedScreen(index) async {
    // pass to Watched Screen with a boolean saying its from here, so that the 'shows' list does not get built

    Database db = await initializeDB();
    List<Map<String, Object?>> res = await db.query("watchD",
        where: "director=? and type='movie' and watchlist='false'",
        whereArgs: [widget.directors.elementAt(index)['director'].toString()]);
    List<Record> movies = res.map((e) => Record.fromMap(e)).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WatchedScreenWidget(
              movies: movies, shows: const [], fromStats: true)),
    );
  }

  Future<Map<String, String>> getImageURLs() async {
    Map<String, String> imageURLs = {};
    for (Map m in widget.directors) {
      String dirname = m['director'].toString();
      String url = await getDirectorImageURL(dirname);
      imageURLs[dirname] = url;
    }
    return imageURLs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 50, 10, 50),
            child: FutureBuilder(
              future: getImageURLs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == null) {
                  return Container();
                }
                return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    controller: listScrollController,
                    itemCount: widget.directors.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () async {
                            navigateToWatchedScreen(index);
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 30, 5, 30),
                                  child: ListTile(
                                    leading: snapshot.hasData
                                        ? ClipOval(
                                            child: Image.network(
                                                (snapshot.data as Map)[widget
                                                    .directors
                                                    .elementAt(
                                                        index)['director']
                                                    .toString()],
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover))
                                        : const ClipOval(
                                            child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.black),
                                          )),
                                    title: Text(
                                        widget.directors[index]['director']
                                            .toString(),
                                        style:
                                            GoogleFonts.poppins(fontSize: 20)),
                                    subtitle: Text(
                                        widget.directors[index]['c'].toString(),
                                        style:
                                            GoogleFonts.poppins(fontSize: 16)),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.arrow_right_sharp),
                                      onPressed: () {
                                        navigateToWatchedScreen(index);
                                      },
                                    ),
                                  ))));
                    });
              },
            )));
  }
}
