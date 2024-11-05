import 'package:aaele/models/timestamps_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MultiLineBarWidget extends StatefulWidget {
  final List<Timestamp> timestamps;
  final String modeType;
  const MultiLineBarWidget({
    Key? key,
    required this.timestamps,
    required this.modeType,
  }) : super(key: key);

  @override
  State<MultiLineBarWidget> createState() => _MultiLineBarWidgetState();
}

class _MultiLineBarWidgetState extends State<MultiLineBarWidget> {
  final style = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  List<LineChartBarData> data = [];
  void dataProcessing() {
    List<FlSpot> happyCoordinates = [];
    List<FlSpot> surprisedCoordinates = [];
    List<FlSpot> confusedCoordinates = [];
    List<FlSpot> boredCoordinates = [];
    List<FlSpot> pnfCoordinates = [];
    for (int i = widget.timestamps.length < 5 ? 0 : widget.timestamps.length - 5; i < widget.timestamps.length; i++) {
      double timestamp = double.parse(
        widget.timestamps[i].timeStamp.substring(0, 2) +
            "." +
            widget.timestamps[i].timeStamp.substring(3),
      );

      happyCoordinates.add(
          FlSpot(timestamp, widget.timestamps[i].emotions[0].happy.toDouble()));
      surprisedCoordinates.add(FlSpot(
          timestamp, widget.timestamps[i].emotions[0].surprised.toDouble()));
      confusedCoordinates.add(FlSpot(
          timestamp, widget.timestamps[i].emotions[0].confused.toDouble()));
      boredCoordinates.add(
          FlSpot(timestamp, widget.timestamps[i].emotions[0].bored.toDouble()));
      pnfCoordinates.add(
          FlSpot(timestamp, widget.timestamps[i].emotions[0].pnf.toDouble()));
    }
    LineChartBarData happyLineChartData = LineChartBarData(
      spots: happyCoordinates,
      color: Colors.green.shade700,
    );
    LineChartBarData surprisedLineChartData = LineChartBarData(
      spots: surprisedCoordinates,
      color: Colors.blue.shade700,
    );
    LineChartBarData confusedLineChartData = LineChartBarData(
      spots: confusedCoordinates,
      color: Colors.red.shade700,
    );
    LineChartBarData boredLineChartData = LineChartBarData(
      spots: boredCoordinates,
      color: Colors.yellow.shade700,
    );
    LineChartBarData pnfLineChartData = LineChartBarData(
      spots: pnfCoordinates,
      color: Colors.lightBlue,
    );
    data.add(happyLineChartData);
    data.add(surprisedLineChartData);
    data.add(confusedLineChartData);
    data.add(boredLineChartData);
    data.add(pnfLineChartData);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataProcessing();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        // boxShadow: [
        //   BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 1, offset: Offset(0,3))
        // ]
      ),
      height: 520,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: Text(
              widget.modeType,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15.0),
          //   child: Text("", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Happy",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 20),
                    Container(
                      height: 10,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Surprised",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 20),
                    Container(
                      height: 10,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Confused",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade700,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Bored",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 24),
                    Container(
                      height: 10,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Person Not Found",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 340,
            height: 300,
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: true, border: Border(top: BorderSide.none, right: BorderSide.none, left: BorderSide(color: Colors.black), bottom: BorderSide(color: Colors.black))),
                gridData: FlGridData(
                  show: true, // Show grid lines
                  horizontalInterval: 2, // Customize horizontal interval
                  drawHorizontalLine: true, // Draw horizontal lines
                  drawVerticalLine: false, // Hide vertical lines
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: const FlTitlesData(
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text("Number of students", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      sideTitles: SideTitles(
                          interval: 1, showTitles: true, reservedSize: 30)),
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text("Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      sideTitles: SideTitles(
                          interval: 0.1, showTitles: true, reservedSize: 30)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: data,
              ),
            ),
          ),
        ],
      ),
    );
  }
}