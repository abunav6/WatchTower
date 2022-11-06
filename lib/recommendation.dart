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
    List<String> genres = [
      'action',
      'adventure',
      'animation',
      'biography',
      'comedy',
      'crime',
      'drama',
      'family',
      'fantasy',
      'horror',
      'mystery',
      'sci-fi',
      'sport',
      'thriller',
      'war'
    ];
    ScrollController controller = ScrollController();

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
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: genres.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () async {
                          showToast(context,
                              "Searching for " + genres[index] + " movies!");
                          showDetails(genres[index], context);
                        },
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5, 30, 5, 30),
                                child: ListTile(
                                  leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                          "assets/genre_images/" +
                                              genres[index] +
                                              ".png",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover)),
                                  title: Text(
                                    "${genres[index][0].toUpperCase()}${(genres[index].substring(1).toLowerCase())}",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  ),
                                  trailing: const Icon(Icons.arrow_right),
                                ))));
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
