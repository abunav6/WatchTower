import 'package:flutter/material.dart';
import "./signedin.dart";

void main() async {
  runApp(const WatchD());
}

class WatchD extends StatelessWidget {
  const WatchD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WatchD',
        theme: ThemeData(
            primarySwatch: Colors.blue, unselectedWidgetColor: Colors.white),
        initialRoute: "/",
        routes: {"/": (context) => const SignedInWidget()});
  }
}
