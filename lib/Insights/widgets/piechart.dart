// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:aaele/models/report_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatefulWidget {
  final String emotionName;
  final List<Emotion> emotions;
  final int sectionIndex;
  const PieChartWidget({
    Key? key,
    required this.emotionName,
    required this.emotions,
    required this.sectionIndex,
  }) : super(key: key);

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int _touchedIndex = -1;
  double overallEmotionPercetage = 0;
  String overallEmotionName = "";

  void calculateOverallEmotionPercentage() {
    double maxValue = 0;
    int maxIndex = -1;
    int totalValue = 0;
    List<double> value = [
      widget.emotions[0].happy,
      widget.emotions[0].surprised,
      widget.emotions[0].confused,
      widget.emotions[0].bored,
      widget.emotions[0].pnf
    ];
    for (int i = 0; i < value.length; i++) {
      totalValue += value[i].toInt();
      if (value[i] > maxValue) {
        maxIndex = i;
        maxValue = max(value[i], maxValue);
      }
    }
    switch (maxIndex) {
      case 0:
        overallEmotionName = "Happy";
        break;
      case 1:
        overallEmotionName = "Surprised";
        break;
      case 2:
        overallEmotionName = "Confused";
        break;
      case 3:
        overallEmotionName = "Bored";
        break;
      case 4:
        overallEmotionName = "Person Not Found";
        break;
      default:
        break;
    }
    overallEmotionPercetage = (maxValue / totalValue) * 100;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateOverallEmotionPercentage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        // boxShadow: [
        //   BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 1, offset: Offset(0,3))
        // ]
      ),
      height: 450,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: Text(
              "${widget.emotionName}: $overallEmotionName",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text("${overallEmotionPercetage.round()}%", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 300,
            child: PieChart(
              swapAnimationDuration: const Duration(milliseconds: 500),
              PieChartData(
                // pieTouchData: PieTouchData(
                //   touchCallback: (FlTouchEvent event, pieTouchResponse) {
                //     setState(() {
                //       // if (!event.isInterestedForInteractions ||
                //       //     pieTouchResponse == null ||
                //       //     pieTouchResponse.touchedSection == null) {
                //       //   _touchedIndex = -1;
                //       //   return;
                //       // }
                //       _touchedIndex =
                //           pieTouchResponse!.touchedSection!.touchedSectionIndex;
                //     });
                //   },
                // ),
                sections: (widget.sectionIndex == 0)
                    ? piechartTextSection(widget.emotions)
                    : ((widget.sectionIndex == 1)
                        ? piechartVideoSection(widget.emotions)
                        : piechartAudioSection(widget.emotions)),
                sectionsSpace: 1,
                centerSpaceRadius: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> piechartTextSection(List<Emotion> emotions) {
    List<Color> sectionColors = [
      Colors.green.shade700,
      Colors.blue.shade700,
      Colors.red.shade700,
      Colors.yellow.shade700,
      Colors.lightBlue,
    ];

    const radius = 150.0;
    const selectedRadius = 160.0;
    const fontSize = 16.0;
    const selectedFontSize = 24.0;

    return [
      PieChartSectionData(
        color: sectionColors[0],
        value: emotions[0].happy,
        title: "Happy ${emotions[0].happy.toInt()}",
        radius: _touchedIndex == 0 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 0 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[1],
        value: emotions[0].surprised,
        title: "Surprised ${emotions[0].surprised.toInt()}",
        radius: _touchedIndex == 1 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 1 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[2],
        value: emotions[0].confused,
        title: "Confused ${emotions[0].confused.toInt()}",
        radius: _touchedIndex == 2 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 2 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[3],
        value: emotions[0].bored,
        title: "Bored ${emotions[0].bored.toInt()}",
        radius: _touchedIndex == 3 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 3 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[4],
        value: emotions[0].pnf,
        title: "PNF ${emotions[0].pnf.toInt()}",
        radius: _touchedIndex == 4 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 4 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    ];
  }

  List<PieChartSectionData> piechartAudioSection(List<Emotion> emotions) {
    List<Color> sectionColors = [
      Colors.green.shade700,
      Colors.blue.shade700,
      Colors.red.shade700,
      Colors.yellow.shade700,
      Colors.lightBlue,
    ];

    const radius = 150.0;
    const selectedRadius = 160.0;
    const fontSize = 16.0;
    const selectedFontSize = 24.0;

    return [
      PieChartSectionData(
        color: sectionColors[0],
        value: emotions[0].happy,
        title: "Happy ${emotions[0].happy.toInt()}",
        radius: _touchedIndex == 0 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 0 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[1],
        value: emotions[0].surprised,
        title: "Surprised ${emotions[0].surprised.toInt()}",
        radius: _touchedIndex == 1 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 1 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[2],
        value: emotions[0].confused,
        title: "Confused ${emotions[0].confused.toInt()}",
        radius: _touchedIndex == 2 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 2 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[3],
        value: emotions[0].bored,
        title: "Bored ${emotions[0].bored.toInt()}",
        radius: _touchedIndex == 3 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 3 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[4],
        value: emotions[0].pnf,
        title: "PNF ${emotions[0].pnf.toInt()}",
        radius: _touchedIndex == 4 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 4 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    ];
  }

  List<PieChartSectionData> piechartVideoSection(List<Emotion> emotions) {
    List<Color> sectionColors = [
      Colors.green.shade700,
      Colors.blue.shade700,
      Colors.red.shade700,
      Colors.yellow.shade700,
      Colors.lightBlue,
    ];

    const radius = 150.0;
    const selectedRadius = 160.0;
    const fontSize = 16.0;
    const selectedFontSize = 24.0;

    return [
      PieChartSectionData(
        color: sectionColors[0],
        value: emotions[0].happy,
        title: "Happy ${emotions[0].happy.toInt()}",
        radius: _touchedIndex == 0 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 0 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[1],
        value: emotions[0].surprised,
        title: "Surprised ${emotions[0].surprised.toInt()}",
        radius: _touchedIndex == 1 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 1 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[2],
        value: emotions[0].confused,
        title: "Confused ${emotions[0].confused.toInt()}",
        radius: _touchedIndex == 2 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 2 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[3],
        value: emotions[0].bored,
        title: "Bored ${emotions[0].bored.toInt()}",
        radius: _touchedIndex == 3 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 3 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
      PieChartSectionData(
        color: sectionColors[4],
        value: emotions[0].pnf,
        title: "PNF ${emotions[0].pnf.toInt()}",
        radius: _touchedIndex == 4 ? selectedRadius : radius,
        titleStyle: TextStyle(
            fontSize: _touchedIndex == 4 ? selectedFontSize : fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    ];
  }
}


class NoDataFound extends StatelessWidget {
  final String emotionName;
  const NoDataFound({
    Key? key,
    required this.emotionName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        // boxShadow: [
        //   BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 1, offset: Offset(0,3))
        // ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: Text(
              "$emotionName: NA",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text("Na%", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
