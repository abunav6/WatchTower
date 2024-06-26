// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously, depend_on_referenced_packages, prefer_interpolation_to_compose_strings, duplicate_ignore, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtvdb/options.dart';
import 'package:mtvdb/person_helper.dart';

import "helper.dart";
import 'secrets.dart';
import 'services/database_handler.dart';

import "youtube.dart";

import 'package:http/http.dart' as http;

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
  bool isLoading = false;
  YoutubeAPI youtube = YoutubeAPI(yt);

  Future<void> _launchYoutubeVideo(String youtubeUrl) async {
    if (youtubeUrl.isNotEmpty) {
      debugPrint(youtubeUrl);
      if (await canLaunch(youtubeUrl)) {
        final bool nativeAppLaunchSucceeded = await launch(
          youtubeUrl,
          forceSafariVC: false,
          universalLinksOnly: true,
        );
        debugPrint(nativeAppLaunchSucceeded.toString());
        if (!nativeAppLaunchSucceeded) {
          await launch(youtubeUrl, forceSafariVC: true);
        }
      }
    }
  }

  Future<void> _launchIMDbPage(String imdbURL) async {
    if (imdbURL.isNotEmpty) {
      if (await canLaunch(imdbURL)) {
        final bool nativeAppLaunchSucceeded = await launch(
          imdbURL,
          forceSafariVC: false,
          universalLinksOnly: true,
        );
        if (!nativeAppLaunchSucceeded) {
          await launch(imdbURL, forceSafariVC: true);
        }
      }
    }
  }

  Widget buildCrewList(List<String> list, String type) {
    debugPrint("I am here");
    ScrollController controller = ScrollController();

    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 100,
        child: FutureBuilder(
            future: Future.wait([
              getImages(type),
              getCharacterNames(widget.title.imdbID, list, widget.title.type)
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return Container();
              }
              if (snapshot.hasData) {
                return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 10,
                      );
                    },
                    itemCount: list.length,
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            int personID = await getPersonID(list[index]);
                            Credits c = await getMovieCredits(personID);

                            if (type == "a") {
                              // actor list
                              List<Cast>? credits = c.cast;
                              credits!;

                              credits.sort((a, b) =>
                                  b.popularity!.compareTo(a.popularity as num));

                              credits = credits.sublist(0, 10);

                              List<SearchDetails> options = [];

                              for (var c in credits) {
                                String? title = c.title as String;
                                String? poster =
                                    "https://image.tmdb.org/t/p/original${c.posterPath as String}";
                                String imdbID = await getIMDBID(c.id as int);

                                String year = c.releaseDate!.split("-")[0];

                                options.add(SearchDetails(
                                    title: title,
                                    year: year,
                                    imdbID: imdbID,
                                    poster: poster));
                              }
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OptionsScreen(options: options)));
                            } else {
                              // writer/director list
                              List<Crew>? credits = c.crew;
                              credits!;

                              credits.sort((a, b) =>
                                  b.popularity!.compareTo(a.popularity as num));

                              credits = credits.sublist(0, 10);

                              List<SearchDetails> options = [];

                              for (var c in credits) {
                                String? title = c.title as String;
                                String? poster =
                                    "https://image.tmdb.org/t/p/original${c.posterPath as String}";
                                String imdbID = await getIMDBID(c.id as int);
                                if (options
                                    .map((e) => e.imdbID)
                                    .contains(imdbID)) {
                                  continue;
                                }
                                String year = c.releaseDate!.split("-")[0];

                                options.add(SearchDetails(
                                    title: title,
                                    year: year,
                                    imdbID: imdbID,
                                    poster: poster));
                              }

                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OptionsScreen(options: options)));
                            }
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 20,
                                  child: Padding(
                                      padding: type != "a"
                                          ? const EdgeInsetsDirectional
                                              .fromSTEB(20, 15, 20, 0)
                                          : const EdgeInsetsDirectional
                                              .fromSTEB(20, 10, 20, 0),
                                      child: ListTile(
                                        leading: snapshot.hasData
                                            ? ClipOval(
                                                child: type != "a"
                                                    ? Image.network(
                                                        ((snapshot.data
                                                                    as List)[0]
                                                                as Map)[
                                                            list[index]],
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover)
                                                    : Image.network(
                                                        getValidURL((((snapshot
                                                                        .data
                                                                    as List)[1]
                                                                as List)[index])
                                                            .profile_path),
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover))
                                            : const ClipOval(
                                                child:
                                                    CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.black),
                                              )),
                                        title: Text(
                                          type != "a"
                                              ? list[index]
                                              : (((snapshot.data as List)[1]
                                                      as List)[index])
                                                  .name,
                                          textAlign: TextAlign.center,
                                        ),
                                        subtitle: type == "a"
                                            ? Text(
                                                (((snapshot.data as List)[1]
                                                        as List)[index])
                                                    .character,
                                                textAlign: TextAlign.center)
                                            : null,
                                        trailing: const Icon(Icons.arrow_right),
                                      )))));
                    });
              } else {
                return Container();
              }
            }));
  }

  Future<Map<String, String>> getImages(String type) async {
    Map<String, String> urls = {};
    List<String> list;
    // verified that the strings coming from widget.title are NEVER empty...

    if (type == "a") {
      list = widget.title.actors.split(",");
    } else if (type == "d") {
      list = widget.title.director.split(",");
    } else {
      list = widget.title.writer.split(",");
    }
    // ... but even if the list is not empty, there is an issue ahead
    for (String name in list) {
      String pURL =
          await getPersonImage(name); // this is the TMDb API Person ID
      if (pURL.isNotEmpty) {
        final re = await http.read(Uri.parse(pURL));
        String imageURL = "";
        List<Profiles>? profiles =
            ImageSearch.fromJson(json.decode(re)).profiles;

        if (profiles != null) {
          try {
            imageURL = "https://image.tmdb.org/t/p/original" +
                (profiles.elementAt(0).filePath as String);
            urls[name] = imageURL;
          } catch (e) {
            //rangeError
            urls[name] =
                "https://p.kindpng.com/picc/s/21-211168_transparent-person-icon-png-png-download.png";
          }
        }
      }
    }
    return urls;
  }

  void getTrailerSearchResults(String title, String year, String type) async {
    String query = Uri.encodeComponent("$title $year $type  trailer");
    String url =
        "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=$query&key=AIzaSyA3WxLx51sMfthV99wJ7hkpDAufnEu3Sck";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      SearchResult sr = SearchResult.fromJson(json.decode(response.body));
      List<Items>? items = sr.items;
      if (items!.isNotEmpty) {
        debugPrint("https://youtube.com/watch/${items[0].id!.videoId!}");
        _launchYoutubeVideo(
            "https://youtube.com/watch/${items[0].id!.videoId!}");
      }
    } else {
      showToast(context, "Error fetching trailer");
    }
  }

  Widget createIMDB(Map<String, String> ratings) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
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
    );
  }

  Widget createRT(Map<String, String> ratings) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
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
    );
  }

  Widget createMeta(Map<String, String> ratings) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
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
    );
  }

  Widget buildMoreInfo(BuildContext context, TitleDetails title) {
    List<String> actors = title.actors.split(",");
    List<String> writers = title.writer.split(",");
    List<String> directors = title.director.split(",");

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
        title.type == "movie"
            ? Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 30, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                        child: Text("Directors",
                            style: GoogleFonts.lexendDeca(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ],
                ),
              )
            : Container(),
        title.type == "movie"
            ? Padding(
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
              )
            : Container(),
        title.type == "movie"
            ? Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 30, 16, 0),
                child: buildCrewList(directors, "d"))
            : Container(),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 30, 16, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Text("Writers",
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
            child: buildCrewList(writers, "w")),
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
            child: buildCrewList(actors, "a")),
      ],
    );
  }

  Widget createTopDrawer(String posterURL) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          Align(
            // BG Image of title poster
            alignment: const AlignmentDirectional(0, 0),
            child: Image.network(
              posterURL,
              width: MediaQuery.of(context).size.width,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            // YT button for trailer
            alignment: const AlignmentDirectional(0.9, -0.84),
            child: IconButton(
              icon: const Icon(FontAwesomeIcons.youtube,
                  color: Colors.white, size: 30),
              onPressed: () {
                debugPrint('trailer pressed ...');
                getTrailerSearchResults(
                    widget.title.title, widget.title.year, widget.title.type);
              },
            ),
          ),
          Align(
            // Back button
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
    );
  }

  Widget createDetailsRow() {
    return Row(
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
                      padding: const EdgeInsetsDirectional.fromSTEB(6, 2, 6, 2),
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
    );
  }

  Widget createRatingsRow() {
    return Row(
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
    );
  }

  Widget addRatingImages(Map<String, String> ratings) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: InkWell(
                onTap: () {
                  _launchIMDbPage(
                      "https://www.imdb.com/title/${widget.title.imdbID}");
                },
                child: createIMDB(ratings),
              )),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 8, 0),
            child: createRT(ratings),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
            child: createMeta(ratings),
          ),
        ),
      ],
    );
  }

  Widget genreRow() {
    return Row(
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
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
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
    );
  }

  Widget addToWatchTowerButton() {
    return ElevatedButton(
        onPressed: () async {
          String rat = "";
          for (Ratings r in widget.title.ratings) {
            if (r.source == "Internet Movie Database") {
              rat = r.value;
            }
          }
          debugPrint("Add to WatchTower");
          Record rec = Record(
              imdbID: widget.title.imdbID,
              title: widget.title.title,
              poster: widget.title.poster,
              type: widget.title.type,
              watchlist: "false",
              year: widget.title.year,
              director: widget.title.director,
              runtime: widget.title.runtime.replaceAll("min", "").trim(),
              imdbRating: rat.replaceAll("/10", ""));

          int code = await fInsert(rec, false);

          if (code == 0) {
            showToast(context, "Added ${widget.title.title} to WatchTower!");
          } else if (code == -1) {
            showToast(context,
                "${rec.title} was in your watchlist! Moving it to the WatchTower list!");
          } else {
            showToast(context,
                "${rec.title} already exists in your WatchTower list!");
          }
          Navigator.pop(context);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xFF4B39EF)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.transparent)))),
        child: Row(children: <Widget>[
          const Icon(Icons.add, size: 15, color: Colors.white,),
          Text("\t Add to WatchTower", style: GoogleFonts.poppins(fontSize: 14, color: Colors.white))
        ]));
  }

  Widget addToWatchlistButton() {
    return ElevatedButton(
        onPressed: () async {
          debugPrint("Add to Watchlist");
          String rat = "";
          for (Ratings r in widget.title.ratings) {
            if (r.source == "Internet Movie Database") {
              rat = r.value;
            }
          }
          Record rec = Record(
              imdbID: widget.title.imdbID,
              title: widget.title.title,
              poster: widget.title.poster,
              type: widget.title.type,
              watchlist: "true",
              year: widget.title.year,
              director: widget.title.director,
              runtime: widget.title.runtime.replaceAll("min", "").trim(),
              imdbRating: rat.replaceAll("/10", ""));
          int code = await fInsert(rec, true);

          if (code == 0) {
            showToast(
                context, "Added ${widget.title.title} to your Watchlist!");
          } else if (code == -2) {
            showToast(context,
                "${widget.title.title} already exists in WatchTower list!");
          } else if (code == -3) {
            showToast(context,
                "${widget.title.title} already exists in your watchlist!");
          }
          Navigator.pop(context);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xFF4B39EF)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.transparent)))),
        child: Row(children: <Widget>[
          const Icon(Icons.bookmark_add, size: 15, color: Colors.white,),
          Text("\t Add to Watchlist", style: GoogleFonts.poppins(fontSize: 14, color: Colors.white))
        ]));
  }

  Widget showTitle() {
    return Padding(
      // Textbox of title title
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
    );
  }

  Widget showTopDrawer(String posterURL) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: createTopDrawer(posterURL),
        ),
      ],
    );
  }

  Widget showDetails() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
      child: createDetailsRow(),
    );
  }

  Widget showBG() {
    return Padding(
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
    );
  }

  Widget showWatchTower() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (widget.showButtons) ? addToWatchTowerButton() : Container()
          ]),
    );
  }

  Widget showWatchlist() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (widget.showButtons) ? addToWatchlistButton() : Container()
            ]));
  }

  Widget buildDetails(
      BuildContext context, Map<String, String> ratings, String posterURL) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          showTopDrawer(posterURL),
          showTitle(),
          showDetails(),
          showBG(),
          createRatingsRow(),
          addRatingImages(ratings),
          genreRow(),
          showWatchTower(),
          showWatchlist(),
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
                    child: Stack(children: [
                  Opacity(
                      opacity: isLoading ? 0.5 : 1,
                      child: TabBarView(children: [
                        buildDetails(context, ratings, posterURL),
                        buildMoreInfo(context, widget.title)
                      ])),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                ]))
              ]))),
    );
  }
}
