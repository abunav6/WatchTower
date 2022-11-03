import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:intl/intl.dart';

class GraphWidget extends StatefulWidget {
  final Map<int, int> yearcount;
  const GraphWidget({Key? key, required this.yearcount}) : super(key: key);

  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class ChartData {
  final int xval;
  final dynamic yval;
  ChartData({required this.xval, required this.yval});
}

class _GraphWidgetState extends State<GraphWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Map<int, int> sorted = Map.fromEntries(widget.yearcount.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));
    final List<ChartData> chartData = [];
    for (int k in sorted.keys) {
      chartData.insert(0, ChartData(xval: k, yval: sorted[k] as int));
    }

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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 100, 20, 100),
                    child: SfCartesianChart(
                      title: ChartTitle(
                        text: "Movies watched per year",
                        textStyle: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      primaryXAxis: DateTimeAxis(
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      primaryYAxis:
                          NumericAxis(majorGridLines: MajorGridLines(width: 0)),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      zoomPanBehavior: ZoomPanBehavior(
                          enablePinching: true, enablePanning: true),
                      series: <ChartSeries>[
                        FastLineSeries<ChartData, DateTime>(
                          dataSource: chartData,
                          color: const Color(0xFF4B39EF),
                          width: 3,
                          enableTooltip: true,
                          markerSettings: MarkerSettings(isVisible: true),
                          xValueMapper: (ChartData data, _) =>
                              DateFormat("yyyy").parse(data.xval.toString()),
                          yValueMapper: (ChartData data, _) => data.yval,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
