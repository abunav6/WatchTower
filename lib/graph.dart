// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtvdb/services/database_handler.dart';
import 'package:mtvdb/yearmovies.dart';
import 'package:sqflite/sqflite.dart';

import 'package:fl_chart/fl_chart.dart';

class GraphWidget extends StatefulWidget {
  final Map<int, int> yearcount;
  const GraphWidget({Key? key, required this.yearcount}) : super(key: key);

  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget buildGraph(Map<int, int> movies) {
    List<FlSpot> spots = [];
    for (int i in movies.keys) {
      spots.insert(
          0,
          FlSpot(double.parse(i.toStringAsFixed(0)),
              double.parse(movies[i]!.toStringAsFixed(0))));
    }

    Widget getLeftWidget(double value, TitleMeta meta) {
      return Text((value.toInt()).toString(),
          style: GoogleFonts.poppins(fontSize: 15, color: Colors.white));
    }

    Widget getBottomWidget(double value, TitleMeta meta) {
      return Text((value.toInt()).toString(),
          style: GoogleFonts.poppins(fontSize: 15, color: Colors.white));
    }

    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
        child: Center(
            child: Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height / 1.6,
                width: MediaQuery.of(context).size.width * 0.9,
                child: LineChart(
                  LineChartData(
                      titlesData: FlTitlesData(
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 5,
                                  reservedSize: 40,
                                  getTitlesWidget: getLeftWidget)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 17,
                                  reservedSize: 40,
                                  getTitlesWidget: getBottomWidget))),
                      gridData: FlGridData(show: false),
                      backgroundColor: Colors.black,
                      lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                          )),
                      lineBarsData: [
                        LineChartBarData(
                            spots: spots,
                            isCurved: false,
                            barWidth: 2,
                            color: Colors.white,
                            dotData: FlDotData(show: true)),
                      ]),
                ))));
  }

  Widget buildList(Map<int, int> movies) {
    ScrollController listScrollController = ScrollController();
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 10,
              );
            },
            controller: listScrollController,
            itemCount: movies.length,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () async {
                    debugPrint(
                        "show the list of movies from ${movies.keys.elementAt(index)}");
                    Database db = await initializeDB();
                    List<Map<String, Object?>> yearMovies = await db.rawQuery(
                        "select imdbID from watchD where year=${movies.keys.elementAt(index)} AND watchlist='false' AND type='movie'");
                    debugPrint(yearMovies.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => YearMoviesWidget(
                                  movies: yearMovies,
                                )));
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 10, 0, 10),
                          child: ListTile(
                            title: Text(movies.keys.elementAt(index).toString(),
                                style: GoogleFonts.poppins(fontSize: 20)),
                            subtitle: Text(
                                movies.values.elementAt(index).toString() == "1"
                                    ? "${movies.values.elementAt(index).toString()} movie"
                                    : "${movies.values.elementAt(index).toString()} movies",
                                style: GoogleFonts.poppins(fontSize: 16)),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_right_sharp),
                              onPressed: () {},
                            ),
                          ))));
            }));
  }

  @override
  Widget build(BuildContext context) {
    Map<int, int> sorted = Map.fromEntries(widget.yearcount.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: true,
          centerTitle: true,
          elevation: 4,
        ),
        body: SafeArea(
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(children: [
              const TabBar(
                tabs: [Tab(text: "Graph"), Tab(text: "List")],
                labelColor: Colors.white,
                indicatorColor: Color(0xFF673AB7),
              ),
              Expanded(
                  child: TabBarView(
                children: [buildGraph(sorted), buildList(sorted)],
              ))
            ]),
          ),
        ));
  }
}
