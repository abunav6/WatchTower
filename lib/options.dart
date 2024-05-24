// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mtvdb/details.dart';
import "helper.dart";

class OptionsScreen extends StatefulWidget {
  // Declare a field that holds the Person data
  final List<SearchDetails> options;
  final bool isTMDBID;

  const OptionsScreen({Key? key, required this.options, required this.isTMDBID}) : super(key: key);

  @override
  _OptionsScreen createState() => _OptionsScreen();
}

class _OptionsScreen extends State<OptionsScreen> {
  final ScrollController controller = ScrollController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(5, 30, 5, 30),
            child: Stack(children: [
              Opacity(
                  opacity: isLoading ? 0.5 : 1,
                  child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: widget.options.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: controller,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });

                              TitleDetails title = await getDetails(!widget.isTMDBID ? 
                                  widget.options[index].imdbID : await getIMDBID(widget.options[index].imdbID));
                              
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsScreenWidget(
                                            title: title,
                                            showButtons: true,
                                          )));
                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            5, 30, 5, 30),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              widget.options[index].poster)),
                                      title: Text(
                                          "${widget.options[index].title} (${widget.options[index].year})"),
                                      trailing: const Icon(Icons.arrow_right),
                                    ))));
                      })),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                )
            ])));
  }
}
