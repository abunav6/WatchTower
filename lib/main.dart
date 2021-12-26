import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import "./signedin.dart";

//import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WatchD());
}

class WatchD extends StatelessWidget {
  const WatchD({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();

  bool passwordVisibility = false;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Text('Welcome to WatchD',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.merriweather(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 40, 20, 0),
                    child: TextFormField(
                      controller: email,
                      obscureText: false,
                      decoration: InputDecoration(
                          hintText: 'Enter your email ID',
                          hintStyle: GoogleFonts.merriweather(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          )),
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                    child: TextFormField(
                      controller: pwd,
                      obscureText: !passwordVisibility,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: GoogleFonts.merriweather(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                        suffixIcon: InkWell(
                          onTap: () => setState(
                            () => passwordVisibility = !passwordVisibility,
                          ),
                          child: Icon(
                            passwordVisibility
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: ElevatedButton(
                          onPressed: () async {
                            print("Login Button");
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email.text, password: pwd.text);
                              showToast(context, "Logging you in!");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignedInWidget()),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                showToast(
                                    context, 'No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                showToast(context,
                                    'Wrong password provided for that user.');
                              }
                            }
                          },
                          child: Text("Login",
                              style: GoogleFonts.merriweather(fontSize: 13)),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      side: const BorderSide(
                                          color: Colors.transparent)))))),
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                      child: TextButton(
                          onPressed: () async {
                            print("Pressed Sign up button");
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email.text, password: pwd.text);
                              showToast(context,
                                  "Signing you up and logging you in!");

                              createTables(email.text);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                showToast(context,
                                    'The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                showToast(
                                    context, "This email is already in use!");
                              }
                            } catch (e) {
                              showToast(context, e.toString());
                            }
                          },
                          child: Text("New here? Sign up!",
                              style: GoogleFonts.merriweather(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showToast(BuildContext context, String s) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(s),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void createTables(String email) async {
    await FirebaseFirestore.instance.collection(email).doc("movies").set({
      "imdbID_here": "movie_name",
    }, SetOptions(merge: true)).then((_) {});
    await FirebaseFirestore.instance.collection(email).doc("series").set({
      "imdbID_here": "series_name",
    }, SetOptions(merge: true)).then((_) {});
    await FirebaseFirestore.instance
        .collection(email)
        .doc("watchlist")
        .collection("movie")
        .doc("movie_watchlist")
        .set({
      "imdbID_here": "series_name",
    }, SetOptions(merge: true)).then((_) {});

    await FirebaseFirestore.instance
        .collection(email)
        .doc("watchlist")
        .collection("series")
        .doc("series_watchlist")
        .set({
      "imdbID_here": "series_name",
    }, SetOptions(merge: true)).then((_) {});
  }
}
