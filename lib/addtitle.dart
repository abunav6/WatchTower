import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import "helper.dart";

class AddTitleWidget extends StatefulWidget {
  const AddTitleWidget({Key? key}) : super(key: key);

  @override
  _AddTitleWidgetState createState() => _AddTitleWidgetState();
}

class _AddTitleWidgetState extends State<AddTitleWidget> {
  bool? movieRadio = false;
  TextEditingController titleName = TextEditingController();
  bool? showRadio = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    titleName = TextEditingController();
  }

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Align(
          alignment: AlignmentDirectional(0, 0),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Text(
                    'Add a Movie or Show to WatchD',
                    style: GoogleFonts.poppins(
                        fontSize: 40, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                  child: Image.asset(
                    'assets/film.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 50, 20, 20),
                  child: TextFormField(
                    controller: titleName,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Enter a Movie\'s or Show\'s name /IMDb ID',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14, fontStyle: FontStyle.italic),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 18),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.multiline,
                  ),
                ),

                // for movie checkbox
                Align(
                  alignment: AlignmentDirectional(-0.9, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: CheckboxListTile(
                      title: Text("Movie",
                          style: GoogleFonts.poppins(fontSize: 14)),
                      value: movieRadio,
                      onChanged: (newValue) {
                        setState(() {
                          movieRadio = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  ),
                ),

                //for series checkbox
                Align(
                  alignment: AlignmentDirectional(-0.9, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                    child: CheckboxListTile(
                      title: Text("Series",
                          style: GoogleFonts.poppins(fontSize: 14)),
                      value: showRadio,
                      onChanged: (newValue) {
                        setState(() {
                          showRadio = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  ),
                ),

                //Button for search by name
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        print("Search by Name");
                        search(movieRadio, showRadio, false, titleName.text);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          minimumSize: MaterialStateProperty.all(
                              Size(double.infinity, 40)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.transparent)))),
                      child: Text("Search by Name",
                          style: GoogleFonts.poppins(fontSize: 14))),
                ),

                //Button for search by IMDB
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        print("Search by IMDb ID");
                        search(movieRadio, showRadio, true, titleName.text);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          minimumSize: MaterialStateProperty.all(
                              Size(double.infinity, 40)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.transparent)))),
                      child: Text("Search by IMDb ID",
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
