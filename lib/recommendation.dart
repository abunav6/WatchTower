import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mtvdb/services/database_handler.dart';
import 'package:sqflite/sqlite_api.dart';
import "helper.dart";
import "details.dart";

class RecommendationWidget extends StatefulWidget {
  const RecommendationWidget({Key? key}) : super(key: key);

  @override
  _RecommendationWidgetState createState() => _RecommendationWidgetState();
}

Future<int> checkIfExists(String imdbID) async {
  final Database db = await initializeDB();
  List<Map<String, Object?>> tmp =
      await db.query("watchD", where: "imdbID=?", whereArgs: [imdbID]);
  if (tmp.isEmpty) {
    // element is not in watchlist or in the watchD list
    return 0;
  }
  return -1;
}

void showDetails(String genre, BuildContext context) async {
  final response =
      await http.get(Uri.parse("http://flaskmtv-abunav6.vercel.app/" + genre));

  if (response.statusCode == 200) {
    LinkedHashMap object = json.decode(response.body)[0];

    TitleDetails recommendation = await getDetails(object['imdbID']);

    if (await checkIfExists(recommendation.imdbID) == -1) {
      // the recommendation exists in DB, wait for a new recommendation
      debugPrint("${recommendation.title} exists in DB!");

      while (true) {
        final response = await http
            .get(Uri.parse("http://flaskmtv-abunav6.vercel.app/" + genre));

        if (response.statusCode == 200) {
          LinkedHashMap object = json.decode(response.body)[0];

          recommendation = await getDetails(object['imdbID']);

          if (await checkIfExists(recommendation.imdbID) == 0) {
            break;
          }
        }
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailsScreenWidget(
                title: recommendation,
                showButtons: true,
              )),
    );
  }
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        actions: const [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 50, 10, 50),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Click a Genre to get a Recommendation:',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                                color: const Color(0xFFB2B0B0),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 80, 10, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 305,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 100, 10, 50),
                        child: GridView(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2.5,
                          ),
                          scrollDirection: Axis.vertical,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  debugPrint('action pressed ...');
                                  showDetails("action", context);
                                },
                                child: Text('Action',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('adventure pressed ...');
                                  showDetails("adventure", context);
                                },
                                child: Text('Adventure',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('animation pressed ...');
                                  showDetails("animation", context);
                                },
                                child: Text('Animation',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('biography pressed ...');
                                  showDetails("biography", context);
                                },
                                child: Text('Biography',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('comedy pressed ...');
                                  showDetails("comedy", context);
                                },
                                child: Text('Comedy',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('crime pressed ...');
                                  showDetails("crime", context);
                                },
                                child: Text('Crime',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('drama pressed ...');
                                  showDetails("drama", context);
                                },
                                child: Text('Drama',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('family pressed ...');
                                  showDetails("family", context);
                                },
                                child: Text('Family',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('fantasy pressed ...');
                                  showDetails("fantasy", context);
                                },
                                child: Text('Fantasy',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('horror pressed ...');
                                  showDetails("horror", context);
                                },
                                child: Text('Horror',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('mystery pressed ...');
                                  showDetails("mystery", context);
                                },
                                child: Text('Mystery',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('scifi pressed ...');
                                  showDetails("scifi", context);
                                },
                                child: Text('Sci-Fi',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('sport pressed ...');
                                  showDetails("sport", context);
                                },
                                child: Text('Sport',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('thriller pressed ...');
                                  showDetails("thriller", context);
                                },
                                child: Text('Thriller',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('war pressed ...');
                                  showDetails("war", context);
                                },
                                child: Text('War',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF4B39EF)),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(80, 40)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                                color: Colors.transparent))))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
