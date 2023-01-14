// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtvdb/details.dart';

import 'helper.dart';

class YearMoviesWidget extends StatefulWidget {
  final List<Map<String, Object?>> movies;
  const YearMoviesWidget({Key? key, required this.movies}) : super(key: key);

  @override
  _YearMoviesWidget createState() => _YearMoviesWidget();
}

class _YearMoviesWidget extends State<YearMoviesWidget> {
  Future<List<TitleDetails>> getList(StreamSink<double> progress) async {
    List<TitleDetails> titles = [];
    int count = 0;
    int total = widget.movies.length;
    for (Map m in widget.movies) {
      String imdbId = m['imdbID'];
      titles.insert(0, await getDetails(imdbId));
      count++;
      progress.add(count / total);
    }
    titles.sort((a, b) => a.title.compareTo(b.title));
    return titles;
  }

  @override
  Widget build(BuildContext context) {
    ScrollController listScrollController = ScrollController();
    StreamController<double> progress = StreamController.broadcast();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 50, 10, 50),
            child: FutureBuilder(
              future: getList(progress.sink),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return StreamBuilder<double>(
                    stream: progress.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: snapshot.data,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                              StreamBuilder(
                                  stream: progress.stream,
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.hasData
                                          ? "${((double.parse(snapshot.data.toString())) * 100).round()}%"
                                          : "",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 12),
                                    );
                                  }),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  );
                } else {
                  progress.close();
                  return ListView.separated(
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsScreenWidget(
                                            title:
                                                (snapshot.data as List)[index],
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
                                              ((snapshot.data as List)[index])
                                                  .poster,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover)),
                                      title: Text(
                                          (snapshot.data as List)[index].title,
                                          style: GoogleFonts.poppins(
                                              fontSize: 20)),
                                      subtitle: Text(
                                          (snapshot.data as List)[index].year,
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
                      });
                }
              },
            )));
  }
}
