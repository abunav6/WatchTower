import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import "helper.dart";
import "services/DatabaseHandler.dart";

import 'package:sqflite/sqflite.dart';

class DetailsScreenWidget extends StatelessWidget {
  final TitleDetails title;
  final bool showButtons;

  const DetailsScreenWidget(
      {Key? key, required this.title, required this.showButtons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, String> ratings = <String, String>{};
    ratings["imdb"] = "NA";
    ratings["RT"] = "NA";
    ratings["meta"] = "NA";

    String posterURL = title.poster;

    if (posterURL == "N/A") {
      posterURL =
          "https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1811/pavelstasevich181101028/112815904-no-image-available-icon-flat-vector-illustration.jpg?ver=6";
    }

    for (int i = 0; i < title.ratings.length; i++) {
      String source = title.ratings[i].source;
      if (source == "Internet Movie Database") {
        ratings["imdb"] = title.ratings[i].value;
      } else if (source == "Rotten Tomatoes") {
        ratings["RT"] = title.ratings[i].value;
      } else if (source == "Metacritic") {
        ratings["meta"] = title.ratings[i].value;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF090F13),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 400,
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Image.network(
                            posterURL,
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(-0.9, -0.84),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Text(title.title,
                          style: GoogleFonts.lexendDeca(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.year,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lexendDeca(
                            color: const Color(0xFF8B97A2),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: const Color(0xFF0F181F),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    6, 2, 6, 2),
                                child: Text(
                                  title.runtime,
                                  style: GoogleFonts.lexendDeca(
                                    color: const Color(0xFF8B97A2),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 1,
                    decoration: const BoxDecoration(
                      color: Color(0xFF353D43),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                        child: Text(
                          'Ratings',
                          style: GoogleFonts.lexendDeca(
                            color: const Color(0xFF8B97A2),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                          child: Text(
                            ratings["imdb"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lexendDeca(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/imdb.png',
                          width: 40,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 8, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                          child: Text(
                            ratings["RT"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lexendDeca(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/rt.png',
                          width: 24,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                          child: Text(
                            ratings["meta"]!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lexendDeca(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/meta.png',
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                          child: Text(
                            'Genre',
                            style: GoogleFonts.lexendDeca(
                              color: const Color(0xFF8B97A2),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          title.genre,
                          style: GoogleFonts.lexendDeca(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (showButtons)
                        ? ElevatedButton(
                            onPressed: () async {
                              debugPrint("Add to WatchD");
                              Record rec = Record(
                                  imdbID: title.imdbID,
                                  title: title.title,
                                  poster: title.poster,
                                  type: title.type,
                                  watchlist: "false");
                              final Database db = await initializeDB();
                              insert(db, rec);
                              debugPrint("added to DB");
                              showToast(
                                  context, "Added ${title.title} to WatchD!");
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF4B39EF)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: const BorderSide(
                                            color: Colors.transparent)))),
                            child: Row(children: <Widget>[
                              const Icon(Icons.add, size: 15),
                              Text("\t Add to WatchD",
                                  style: GoogleFonts.poppins(fontSize: 14))
                            ]))
                        : Container()
                  ]),
            ),
            Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (showButtons)
                          ? ElevatedButton(
                              onPressed: () async {
                                debugPrint("Add to Watchlist");
                                Record rec = Record(
                                    imdbID: title.imdbID,
                                    title: title.title,
                                    poster: title.poster,
                                    type: title.type,
                                    watchlist: "true");
                                insert(await initializeDB(), rec);
                                showToast(context,
                                    "Added ${title.title} to your Watchlist!");
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF4B39EF)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                              color: Colors.transparent)))),
                              child: Row(children: <Widget>[
                                const Icon(Icons.add, size: 15),
                                Text("\t Add to Watchlist",
                                    style: GoogleFonts.poppins(fontSize: 14))
                              ]))
                          : Container()
                    ])),
          ],
        ),
      ),
    );
  }
}
