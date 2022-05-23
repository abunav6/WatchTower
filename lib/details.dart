import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import "helper.dart";
import 'services/database_handler.dart';

import "youtube.dart";

import 'package:http/http.dart' as http;

import 'package:sqflite/sqflite.dart';

import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:youtube_api/youtube_api.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreenWidget extends StatefulWidget {
  final TitleDetails title;
  final bool showButtons;

  const DetailsScreenWidget(
      {Key? key, required this.title, required this.showButtons})
      : super(key: key);

  @override
  _DetailsScreenWidget createState() => _DetailsScreenWidget();
}

class _DetailsScreenWidget extends State<DetailsScreenWidget> {
  List<YouTubeVideo> videoResult = [];
  YoutubeAPI youtube = YoutubeAPI("AIzaSyA3WxLx51sMfthV99wJ7hkpDAufnEu3Sck");

  Future<void> _launchYoutubeVideo(String _youtubeUrl) async {
    if (_youtubeUrl.isNotEmpty) {
      if (await canLaunch(_youtubeUrl)) {
        final bool _nativeAppLaunchSucceeded = await launch(
          _youtubeUrl,
          forceSafariVC: false,
          universalLinksOnly: true,
        );
        if (!_nativeAppLaunchSucceeded) {
          await launch(_youtubeUrl, forceSafariVC: true);
        }
      }
    }
  }

  void getResults(String title, String year, String type) async {
    String query =
        Uri.encodeComponent(title + " " + year + " " + type + " " + " trailer");
    String url =
        "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=" +
            query +
            "&key=AIzaSyA3WxLx51sMfthV99wJ7hkpDAufnEu3Sck";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      SearchResult sr = SearchResult.fromJson(json.decode(response.body));
      List<Items>? items = sr.items;
      if (items!.isNotEmpty) {
        debugPrint("https://youtube.com/watch/" + items[0].id!.videoId!);
        _launchYoutubeVideo(
            "https://youtube.com/watch/" + items[0].id!.videoId!);
      }
    } else {
      showToast(context, "Error fetching trailer");
    }
  }

  Widget buildMoreInfo(BuildContext context, TitleDetails title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Text("Plot",
                      style: GoogleFonts.lexendDeca(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
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
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.plot,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.lexendDeca(
                    color: const Color(0xFF8B97A2),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 30, 16, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Text("Director",
                      style: GoogleFonts.lexendDeca(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
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
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.director,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.lexendDeca(
                    color: const Color(0xFF8B97A2),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 30, 16, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Text("Writer",
                      style: GoogleFonts.lexendDeca(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
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
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.writer,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.lexendDeca(
                    color: const Color(0xFF8B97A2),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 30, 16, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Text("Actors",
                      style: GoogleFonts.lexendDeca(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
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
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.actors,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.lexendDeca(
                    color: const Color(0xFF8B97A2),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget buildDetails(
      BuildContext context, Map<String, String> ratings, String posterURL) {
    return SingleChildScrollView(
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
                        alignment: const AlignmentDirectional(0.9, -0.84),
                        child: IconButton(
                          icon: const Icon(FontAwesomeIcons.youtube,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            debugPrint('trailer pressed ...');
                            getResults(widget.title.title, widget.title.year,
                                widget.title.type);
                          },
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
                    child: Text(widget.title.title,
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
                        widget.title.year,
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
                                widget.title.runtime,
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
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
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
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
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
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
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
                          'Genre',
                          style: GoogleFonts.lexendDeca(
                            color: const Color(0xFF8B97A2),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        widget.title.genre,
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
                  (widget.showButtons)
                      ? ElevatedButton(
                          onPressed: () async {
                            debugPrint("Add to WatchD");
                            Record rec = Record(
                                imdbID: widget.title.imdbID,
                                title: widget.title.title,
                                poster: widget.title.poster,
                                type: widget.title.type,
                                watchlist: "false",
                                year: widget.title.year);
                            final Database db = await initializeDB();
                            int code = await insert(db, rec, false);
                            if (code == 0) {
                              debugPrint("added to DB");
                              showToast(
                                  context, "Added ${widget.title.title} to WatchD!");
                            } else if (code == -1) {
                              showToast(context,
                                  "${rec.title} was in your watchlist! Moving it to the WatchD list!");
                            } else if (code == -2) {
                              showToast(context,
                                  "${rec.title} already exists in your WatchD list!");
                            }
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF4B39EF)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
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
                    (widget.showButtons)
                        ? ElevatedButton(
                            onPressed: () async {
                              debugPrint("Add to Watchlist");
                              Record rec = Record(
                                  imdbID: widget.title.imdbID,
                                  title: widget.title.title,
                                  poster: widget.title.poster,
                                  type: widget.title.type,
                                  watchlist: "true",
                                  year: widget.title.year);
                              int code =
                                  await insert(await initializeDB(), rec, true);
                              if (code == 0) {
                                showToast(context,
                                    "Added ${widget.title.title} to your Watchlist!");
                              } else if (code == -2) {
                                showToast(context,
                                    "${widget.title.title} already exists in WatchD list!");
                              } else if (code == -3) {
                                showToast(context,
                                    "${widget.title.title} already exists in your watchlist!");
                              }
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
                              const Icon(Icons.bookmark_add, size: 15),
                              Text("\t Add to Watchlist",
                                  style: GoogleFonts.poppins(fontSize: 14))
                            ]))
                        : Container()
                  ])),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> ratings = <String, String>{};
    ratings["imdb"] = "NA";
    ratings["RT"] = "NA";
    ratings["meta"] = "NA";

    String posterURL = widget.title.poster;

    if (posterURL == "N/A") {
      posterURL =
          "https://us.123rf.com/450wm/pavelstasevich/pavelstasevich1811/pavelstasevich181101028/112815904-no-image-available-icon-flat-vector-illustration.jpg?ver=6";
    }

    for (int i = 0; i < widget.title.ratings.length; i++) {
      String source = widget.title.ratings[i].source;
      if (source == "Internet Movie Database") {
        ratings["imdb"] = widget.title.ratings[i].value;
      } else if (source == "Rotten Tomatoes") {
        ratings["RT"] = widget.title.ratings[i].value;
      } else if (source == "Metacritic") {
        ratings["meta"] = widget.title.ratings[i].value;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF090F13),
      body: SafeArea(
          child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Column(children: [
                const TabBar(
                  labelColor: Colors.white,
                  indicatorColor: Color(0xFF673AB7),
                  tabs: [
                    Tab(text: "Overview"),
                    Tab(text: "More Info"),
                  ],
                ),
                Expanded(
                    child: TabBarView(children: [
                  buildDetails(context, ratings, posterURL),
                  buildMoreInfo(context, widget.title)
                ]))
              ]))),
    );
  }
}
