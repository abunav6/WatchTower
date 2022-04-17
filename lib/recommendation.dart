import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "dart:collection";

class RecommendationWidget extends StatefulWidget {
  const RecommendationWidget({Key? key}) : super(key: key);

  @override
  _RecommendationWidgetState createState() => _RecommendationWidgetState();
}

void reset(Map<String, bool> map) {
  for (String i in map.keys) {
    map[i] = false;
  }
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var genres = <String>[];

  Map<String, bool> buttons = {
    "action": false,
    "adventure": false,
    "animation": false,
    "crime": false,
    "comedy": false,
    "drama": false,
    "fantasy": false,
    "horror": false,
    "mystery": false,
    "scifi": false,
    "thriller": false,
    "war": false,
  };

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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Choose Genre(s) below:',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFAFAFAF),
                    fontStyle: FontStyle.italic,
                  )),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: GridView(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 2.5,
                                ),
                                scrollDirection: Axis.vertical,
                                children: [
                                  ElevatedButton(
                                      onPressed: () => setState(() =>
                                          buttons["action"] =
                                              !(buttons["action"]!)),
                                      child: Text("Action",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["action"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["action"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(130, 40)),
                                          shape:
                                              MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () => setState(() =>
                                          buttons["adventure"] =
                                              !(buttons["adventure"]!)),
                                      child: Text("Adventure",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["adventure"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["adventure"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () => setState(() =>
                                          buttons["animation"] =
                                              !(buttons["animation"]!)),
                                      child: Text("Animation",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["animation"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["animation"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () => setState(() =>
                                          buttons["comedy"] =
                                              !(buttons["comedy"]!)),
                                      child: Text("Comedy",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["comedy"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["comedy"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(130, 40)),
                                          shape:
                                              MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () => setState(() => buttons["crime"] =
                                          !(buttons["crime"]!)),
                                      child: Text("Crime",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["crime"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["crime"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () => setState(() => buttons["drama"] =
                                          !(buttons["drama"]!)),
                                      child: Text("Drama",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["drama"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["drama"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () => setState(() =>
                                          buttons["fantasy"] =
                                              !(buttons["fantasy"]!)),
                                      child: Text("Fantasy",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["fantasy"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["fantasy"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () => setState(() =>
                                          buttons["horror"] =
                                              !(buttons["horror"]!)),
                                      child: Text("Horror",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["horror"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["horror"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(130, 40)),
                                          shape:
                                              MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () => setState(() =>
                                          buttons["mystery"] =
                                              !(buttons["mystery"]!)),
                                      child: Text("Mystery",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["mystery"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["mystery"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () => setState(() => buttons["scifi"] =
                                          !(buttons["scifi"]!)),
                                      child: Text("Sci-Fi",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["scifi"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["scifi"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () => setState(() =>
                                          buttons["thriller"] =
                                              !(buttons["thriller"]!)),
                                      child: Text("Thriller",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["thriller"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["thriller"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () => setState(() =>
                                          buttons["war"] = !(buttons["war"]!)),
                                      child: Text("War",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              textStyle: TextStyle(
                                                  color: buttons["war"]!
                                                      ? Colors.black
                                                      : Colors.white))),
                                      style: ButtonStyle(
                                          backgroundColor: buttons["war"]!
                                              ? MaterialStateProperty.all(
                                                  const Color(0xFFFFFFFF))
                                              : MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent))))),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Color(0xFFB2B0B0),
                                      size: 17,
                                    ),
                                    onPressed: () {
                                      debugPrint('submit pressed ...');

                                      for (String i in buttons.keys) {
                                        if (buttons[i]!) {
                                          debugPrint("adding " +
                                              i +
                                              " to the selected genre(s)");
                                          genres.add(i);
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Color(0xFFB2B0B0),
                                      size: 17,
                                    ),
                                    onPressed: () =>
                                        setState(() => reset(buttons)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        const TabBar(
                          labelColor: Colors.white,
                          indicatorColor: Color(0xFF4B39EF),
                          tabs: [
                            Tab(
                              text: 'Movies',
                            ),
                            Tab(
                              text: 'Series',
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Container(),
                              Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
