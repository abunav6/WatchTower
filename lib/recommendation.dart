import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendationWidget extends StatefulWidget {
  const RecommendationWidget({Key? key}) : super(key: key);

  @override
  _RecommendationWidgetState createState() => _RecommendationWidgetState();
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
        actions: [],
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
                                      onPressed: () {
                                        debugPrint('action pressed ...');
                                      },
                                      child: Text("Action",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Adventure pressed ...');
                                      },
                                      child: Text("Adventure",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Animation pressed ...');
                                      },
                                      child: Text("Animation",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Crime pressed ...');
                                      },
                                      child: Text("Crime",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Comedy pressed ...');
                                      },
                                      child: Text("Comedy",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Drama pressed ...');
                                      },
                                      child: Text("Drama",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Fantasy pressed ...');
                                      },
                                      child: Text("Fantasy",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Horror pressed ...');
                                      },
                                      child: Text("Horror",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Mystery pressed ...');
                                      },
                                      child: Text("Mystery",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Sci-fi pressed ...');
                                      },
                                      child: Text("Sci-Fi",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Thriller pressed ...');
                                      },
                                      child: Text("Thriller",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
                                  ElevatedButton(
                                      onPressed: () {
                                        debugPrint('War pressed ...');
                                      },
                                      child: Text("War",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13)),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF4B39EF)),
                                          minimumSize: MaterialStateProperty.all(
                                              const Size(130, 40)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  side: const BorderSide(
                                                      color:
                                                          Colors.transparent))))),
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
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Color(0xFFB2B0B0),
                                      size: 17,
                                    ),
                                    onPressed: () {
                                      debugPrint('clear pressed ...');
                                    },
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
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        TabBar(
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
