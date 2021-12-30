import 'package:flutter/material.dart';
import 'package:mtvdb/details.dart';
import "helper.dart";
import 'package:google_fonts/google_fonts.dart';

class OptionsScreen extends StatelessWidget {
  // Declare a field that holds the Person data
  final List<SearchDetails> options;

  ScrollController controller = ScrollController();

  OptionsScreen({Key? key, required this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(5, 30, 5, 30),
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: options.length,
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () async {
                        TitleDetails title =
                            await getDetails(options[index].imdbID);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsScreenWidget(title: title)));
                      },
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 30, 5, 30),
                              child: ListTile(
                                leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(options[index].poster)),
                                title: Text(
                                    "${options[index].title} (${options[index].year})"),
                                trailing: const Icon(Icons.arrow_right),
                              ))));
                })));
  }
}
