// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtvdb/recommendation.dart';
import 'addtitle.dart';
import "helper.dart";
import 'services/database_handler.dart';
import "watched.dart";
import "watchlist.dart";

import 'package:sqflite/sqflite.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 50, 10, 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 10),
                      child: Image.asset(
                        'assets/movie_logo.png',
                        width: MediaQuery.of(context).size.width * 2,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 70),
                      child: Text(
                        'WatchD',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 40, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: ElevatedButton(
                          onPressed: () {
                            debugPrint("Need to add a movie");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddTitleWidget()));
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF4B39EF)),
                              minimumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 40)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: const BorderSide(
                                          color: Colors.transparent)))),
                          child: Text("Search for a Movie or Show",
                              style: GoogleFonts.poppins(fontSize: 14))),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: ElevatedButton(
                          onPressed: () async {
                            debugPrint("View your watched stuff");

                            List<Record> movieResponse =
                                await fRetrieveData("movie", "false");

                            List<Record> showResponse =
                                await fRetrieveData("series", "false");

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WatchedScreenWidget(
                                        movies: movieResponse,
                                        shows: showResponse,
                                        fromStats: false,
                                      )),
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF4B39EF)),
                              minimumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 40)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: const BorderSide(
                                          color: Colors.transparent)))),
                          child: Text("Your WatchD list",
                              style: GoogleFonts.poppins(fontSize: 14))),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: ElevatedButton(
                          onPressed: () async {
                            List<Record> movies =
                                await fRetrieveData("movie", "true");

                            List<Record> shows =
                                await fRetrieveData("series", "true");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WatchlistWidget(
                                      movies: movies, shows: shows)),
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF4B39EF)),
                              minimumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 40)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: const BorderSide(
                                          color: Colors.transparent)))),
                          child: Text("Your Watchlist",
                              style: GoogleFonts.poppins(fontSize: 14))),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                      child: ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RecommendationWidget()),
                            );
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF4B39EF)),
                              minimumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 40)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: const BorderSide(
                                          color: Colors.transparent)))),
                          child: Text("Get a Movie Recommendation!",
                              style: GoogleFonts.poppins(fontSize: 14))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
