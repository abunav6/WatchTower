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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 50, 10, 50),
            child: ListView.separated(
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
                        Database db = await initializeDB();
                        List<Map<String, Object?>> res = await db.query(
                            "watchD",
                            where:
                                "director=? and type='movie' and watchlist='false'",
                            whereArgs: [
                              widget.directors
                                  .elementAt(index)['director']
                                  .toString()
                            ]);
                        List<Record> movies =
                            res.map((e) => Record.fromMap(e)).toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WatchedScreenWidget(
                                  movies: movies,
                                  shows: const [],
                                  fromStats: true)),
                        );
                        // pass to Watched Screen with a boolean saying its from here, so that the shows list does not get built
                      },
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 30, 5, 30),
                              child: ListTile(
                                  // leading: CircleAvatar(
                                  //     radius: 30,
                                  //     backgroundImage: NetworkImage(
                                  //         getDirectorImageURL(widget.directors
                                  //             .elementAt(index)['director']
                                  //             .toString()))),
                                  title: Text(
                                      widget.directors[index]['director']
                                          .toString(),
                                      style: GoogleFonts.poppins(fontSize: 22)),
                                  subtitle: Text(
                                      widget.directors[index]['c'].toString(),
                                      style: GoogleFonts.poppins(
                                          fontSize: 16))))));
                })));
  }
}
