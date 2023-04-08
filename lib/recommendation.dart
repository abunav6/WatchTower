// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import "helper.dart";
import "details.dart";

class RecommendationWidget extends StatefulWidget {
  const RecommendationWidget({Key? key}) : super(key: key);

  @override
  _RecommendationWidgetState createState() => _RecommendationWidgetState();
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  void showDetails(BuildContext context, String genre) async {
    setState(() {
      isLoading = true;
    });

    TitleDetails recommendation;
    while (true) {
      final response = await http
          .get(Uri.parse("http://flaskmtv-abunav6.vercel.app/$genre"));

      if (response.statusCode == 200) {
        LinkedHashMap object = json.decode(response.body)[0];
        if (await checkIfExists(object['imdbID']) == 0) {
          recommendation = await getDetails(object['imdbID']);
          break;
        }
      }
    }

    setState(() {
      isLoading = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailsScreenWidget(
                title: recommendation,
                showButtons: true,
              )),
    );
    // }
  }

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
                child: Stack(
                  children: [
                    Opacity(
                        opacity: isLoading ? 0.5 : 1,
                        child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
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
                                        "Searching for ${genres[index]} movies!");
                                    showDetails(context, genres[index]);
                                  },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(5, 30, 5, 30),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                                radius: 30,
                                                backgroundColor: Colors.white,
                                                child: Image.asset(
                                                    "assets/genre_images/${genres[index]}.png",
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover)),
                                            title: Text(
                                              "${genres[index][0].toUpperCase()}${(genres[index].substring(1).toLowerCase())}",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black),
                                            ),
                                            trailing:
                                                const Icon(Icons.arrow_right),
                                          ))));
                            })),
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black)),
                      )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
