import 'package:flutter/material.dart';
import "helper.dart";

class OptionsScreen extends StatelessWidget {
  // Declare a field that holds the Person data
  final List<SearchDetails> options;

  OptionsScreen({Key? key, required this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(5, 30, 5, 30),
            child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                          title: Text(options[index].title),
                          onTap: () {
                            debugPrint(options[index].imdbID);
                          }));
                })));
  }

  void onTap(int index) {}
}
