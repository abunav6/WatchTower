import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import "./signedin.dart";

void main() async {
  runApp(const WatchD());
}

class WatchD extends StatelessWidget {
  const WatchD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _cleanUpTemporaryDirectory();
    return MaterialApp(
        title: 'WatchD',
        theme: ThemeData(
            primarySwatch: Colors.blue, unselectedWidgetColor: Colors.white),
        initialRoute: "/",
        routes: {"/": (context) => const SignedInWidget()});
  }

  void _cleanUpTemporaryDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    documentsDirectory.parent.list().forEach((child) async {
      if (child is Directory && child.path.endsWith('/tmp')) {
        debugPrint('Deleting temp folder at ${child.path}...');
        try {
          await child.delete(recursive: true);
          debugPrint('Temp folder was deleted with success');
        } catch (error) {
          debugPrint('Temp folder could not be deleted: $error');
        }
      }
    });
  }
}
