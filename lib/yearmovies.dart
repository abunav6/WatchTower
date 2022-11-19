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
  Future<List<TitleDetails>> getList() async {
    List<TitleDetails> titles = [];
    for (Map m in widget.movies) {
      String imdbId = m['imdbID'];
      titles.insert(0, await getDetails(imdbId));
    }
    return titles;
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    ScrollController listScrollController = ScrollController();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 50, 10, 50),
            child: FutureBuilder(
              future: getList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  debugPrint("still fetching?");
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  )));
                } else {
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
