// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtvdb/details.dart';

import 'helper.dart';

class YearMoviesWidget extends StatefulWidget {
  final List<Record> movies;
  const YearMoviesWidget({Key? key, required this.movies}) : super(key: key);

  @override
  _YearMoviesWidget createState() => _YearMoviesWidget();
}

class _YearMoviesWidget extends State<YearMoviesWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    ScrollController listScrollController = ScrollController();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 50, 10, 50),
            child: Stack(children: [
              Opacity(
                  opacity: isLoading ? 0.5 : 1,
                  child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      controller: listScrollController,
                      itemCount: widget.movies.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });

                              TitleDetails td =
                                  await getDetails(widget.movies[index].imdbID);

                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsScreenWidget(
                                            title: td,
                                            showButtons: false,
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
                                      leading: ClipOval(
                                          child: Image.network(
                                              (widget.movies[index]).poster,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover)),
                                      title: Text(widget.movies[index].title,
                                          style: GoogleFonts.poppins(
                                              fontSize: 20)),
                                      subtitle: Text(widget.movies[index].year,
                                          style: GoogleFonts.poppins(
                                              fontSize: 16)),
                                      trailing: IconButton(
                                        icon:
                                            const Icon(Icons.arrow_right_sharp),
                                        onPressed: () {
                                          debugPrint(
                                              "need to show details for this movie");
                                        },
                                      ),
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
