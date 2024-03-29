// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtvdb/directors.dart';
import 'package:mtvdb/moviesthroughyears.dart';
import 'package:mtvdb/helper.dart';
import 'package:mtvdb/services/database_handler.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'details.dart';

class StatsWidget extends StatefulWidget {
  final Map<String, int> dd;
  final String id, rd, ard;
  final TitleDetails max, min;
  const StatsWidget(
      {Key? key,
      required this.dd,
      required this.rd,
      required this.max,
      required this.min,
      required this.id,
      required this.ard})
      : super(key: key);

  @override
  _StatsWidgetState createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  final bool _showRating = true;

  Future<String> getTopDirImage() async {
    return await (getDirectorImageURL(widget.dd.keys.elementAt(0).toString()));
  }

  String get avgTitle {
    if (!_showRating) {
      return 'Average Rating';
    } else {
      return 'Average Runtime';
    }
  }

  String get avgData {
    if (!_showRating) {
      return "${widget.id}/10.0";
    } else {
      return "${widget.ard} mins";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 4,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text('Here are your WatchTower stats!',
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                2, 2, 2, 12),
                            child: GestureDetector(
                                onTap: () async {
                                  TitleDetails title =
                                      await getDetails(widget.max.imdbID);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailsScreenWidget(
                                              title: title,
                                              showButtons: false,
                                            )),
                                  );
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  height: 190,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x34090F13),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 8, 12, 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 12, 0, 0),
                                          child: Text('Longest Movie',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      const Color(0xff121212))),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 4, 0, 0),
                                                child: Text(
                                                    "${widget.max.title}\n${widget.max.runtime}",
                                                    softWrap: true,
                                                    maxLines:
                                                        2, // replace with name of longest movie
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                      color: const Color(
                                                          0xFF8B97A2),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 8, 0, 0),
                                            child: LinearPercentIndicator(
                                              percent: 0.95,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38,
                                              lineHeight: 8,
                                              animation: true,
                                              progressColor:
                                                  const Color(0xFFA43507),
                                              backgroundColor:
                                                  const Color(0xffE0E3E7),
                                              barRadius:
                                                  const Radius.circular(8),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                2, 2, 2, 12),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.44,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color(0x34090F13),
                                    offset: Offset(0, 2),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 8, 12, 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 12, 0, 0),
                                      child: InkWell(
                                        onTap: () async {},
                                        child: Text("Average Rating",
                                            style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    const Color(0xff121212))),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 20, 0, 0),
                                      child: Text("${widget.id}/10.0",
                                          style: GoogleFonts.lexendDeca(
                                            color: const Color(0xFF8B97A2),
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                2, 2, 2, 12),
                            child: GestureDetector(
                                onTap: () async {
                                  Map<String, int> yearMap = await getyearMap();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GraphWidget(
                                                yearcount: yearMap,
                                              )));
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  height: 135,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x34090F13),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 8, 12, 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 12, 0, 0),
                                          child: Text(
                                              'Your Movies \nThrough the Years',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      const Color(0xff121212))),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  2, 2, 2, 12),
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DirectorsScreenWidget(
                                                  directors: widget.dd)));
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  height: 279,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x34090F13),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 8, 12, 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                                'Top 10 Most \nWatched Directors',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(
                                                        0xff121212))),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 0),
                                              child: Text(
                                                  "${widget.dd.keys.elementAt(0)} - ${widget.dd.values.elementAt(0)}", // replace with name of most viewed director
                                                  style: GoogleFonts.lexendDeca(
                                                    color:
                                                        const Color(0xFF8B97A2),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 16, 0, 16),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FutureBuilder(
                                                future: getTopDirImage(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState ==
                                                          ConnectionState
                                                              .none &&
                                                      snapshot.hasData ==
                                                          false) {
                                                    return Container();
                                                  }
                                                  return snapshot.hasData
                                                      ? Image.network(
                                                          snapshot.data
                                                              as String, // replace with Image URL of director
                                                          width: 140,
                                                          height: 140,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : const ClipOval(
                                                          child:
                                                              CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors.black),
                                                        ));
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                2, 2, 2, 12),
                            child: GestureDetector(
                                onTap: () async {
                                  TitleDetails title =
                                      await getDetails(widget.min.imdbID);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailsScreenWidget(
                                              title: title,
                                              showButtons: false,
                                            )),
                                  );
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x34090F13),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 8, 12, 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 12, 0, 0),
                                          child: Text('Shortest Movie',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      const Color(0xff121212))),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 4, 0, 0),
                                                child: Text(
                                                    "${widget.min.title}\n${widget.min.runtime}", // replace with name of shortest movie
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                      color: const Color(
                                                          0xFF8B97A2),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 8, 0, 0),
                                            child: LinearPercentIndicator(
                                              percent: 0.2,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.38,
                                              lineHeight: 8,
                                              animation: true,
                                              progressColor:
                                                  const Color(0xFFA43507),
                                              backgroundColor:
                                                  const Color(0xffE0E3E7),
                                              barRadius:
                                                  const Radius.circular(8),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 10, 0, 0),
                      child: SelectionArea(
                          child: Text(
                              'You\'ve spent ${widget.rd} minutes watching\nmovies!\nThat\'s ${widget.ard} minutes per movie, on average!',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
