// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtvdb/options.dart';
import "details.dart";

import "helper.dart";

class AddTitleWidget extends StatefulWidget {
  const AddTitleWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddTitleWidgetState createState() => _AddTitleWidgetState();
}

class _AddTitleWidgetState extends State<AddTitleWidget> {
  bool? movieRadio = false;
  TextEditingController titleName = TextEditingController();
  bool? showRadio = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
              child: Stack(children: [
                Opacity(
                    opacity: isLoading ? 0.5 : 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Text(
                            'Add a Movie or Show to WatchTower',
                            style: GoogleFonts.poppins(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                          child: Image.asset(
                            'assets/film.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 50, 20, 20),
                          child: TextFormField(
                            controller: titleName,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText:
                                  'Enter a Movie\'s or Show\'s name /IMDb ID',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white38),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                            ),
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),

                        // for movie checkbox
                        Align(
                          alignment: const AlignmentDirectional(-0.9, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 5),
                            child: CheckboxListTile(
                              title: Text("Movie",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.white)),
                              value: movieRadio,
                              onChanged: (newValue) {
                                setState(() {
                                  movieRadio = newValue;
                                });
                              },
                              activeColor: const Color(0xFF4B39EF),
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                          ),
                        ),

                        //for series checkbox
                        Align(
                          alignment: const AlignmentDirectional(-0.9, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 5),
                            child: CheckboxListTile(
                              title: Text("Series",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.white)),
                              value: showRadio,
                              onChanged: (newValue) {
                                setState(() {
                                  showRadio = newValue;
                                });
                              },
                              activeColor: const Color(0xFF4B39EF),
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                          ),
                        ),

                        //Button for search by name
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: ElevatedButton(
                              onPressed: () async {
                                debugPrint("Search by Name");

                                if (titleName.text.trim() != "") {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  List<SearchDetails> options =
                                      await searchByName(movieRadio, showRadio,
                                          titleName.text.trim());
                                  debugPrint("${options.length}");
                                  if (options.isNotEmpty) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OptionsScreen(
                                                options: options)));
                                  } else {
                                    if (movieRadio == true &&
                                        showRadio == true) {
                                      showToast(context,
                                          "You cannot search for both; Choose one!");
                                    } else if (movieRadio == false &&
                                        showRadio == false) {
                                      showToast(context,
                                          "You have to search for at least one!");
                                    } else if (movieRadio == null &&
                                        showRadio == null) {
                                      showToast(context,
                                          "You have to search for at least one!");
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                } else {
                                  showToast(
                                      context, "You need to enter something!");
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF4B39EF)),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(double.infinity, 40)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                              color: Colors.transparent)))),
                              child: Text("Search by Name",
                                  style: GoogleFonts.poppins(fontSize: 14))),
                        ),

                        //Button for search by IMDB
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: ElevatedButton(
                              onPressed: () async {
                                debugPrint("Search by IMDb ID");
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  TitleDetails title =
                                      await searchByID(titleName.text.trim());
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsScreenWidget(
                                                  title: title,
                                                  showButtons: true)));
                                } catch (_) {
                                  showToast(context, "Incorrect IMDb ID");
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF4B39EF)),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(double.infinity, 40)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                              color: Colors.transparent)))),
                              child: Text("Search by IMDb ID",
                                  style: GoogleFonts.poppins(fontSize: 14))),
                        ),
                      ],
                    )),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
              ])),
        ),
      ),
    );
  }
}
