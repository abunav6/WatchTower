import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'addtitle.dart';

class SignedInWidget extends StatefulWidget {
  const SignedInWidget({Key? key}) : super(key: key);

  @override
  _SignedInWidgetState createState() => _SignedInWidgetState();
}

class _SignedInWidgetState extends State<SignedInWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        actions: const [],
        centerTitle: true,
        elevation: 10,
      ),
      backgroundColor: Colors.white,
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
                  padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 10),
                  child: Image.asset(
                    'assets/movie_logo.jpg',
                    width: MediaQuery.of(context).size.width * 2,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 70),
                  child: Text(
                    'WatchD',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: ElevatedButton(
                      onPressed: () {
                        debugPrint("Need to add a movie");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddTitleWidget()),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 40)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: const BorderSide(
                                          color: Colors.transparent)))),
                      child: Text("Add a Movie",
                          style: GoogleFonts.poppins(fontSize: 14))),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: ElevatedButton(
                      onPressed: () {
                        debugPrint("View your watched movies");
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 40)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: const BorderSide(
                                          color: Colors.transparent)))),
                      child: Text("Your WatchD list",
                          style: GoogleFonts.poppins(fontSize: 14))),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        debugPrint("Need to add a movie/series to watchlist");
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 40)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: const BorderSide(
                                          color: Colors.transparent)))),
                      child: Text("Your Watchlist",
                          style: GoogleFonts.poppins(fontSize: 14))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
