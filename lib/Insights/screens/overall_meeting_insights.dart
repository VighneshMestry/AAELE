// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'package:aaele/Insights/widgets/mulitlinebar.dart';
import 'package:aaele/Insights/widgets/piechart.dart';
import 'package:aaele/models/overall_meeting_model.dart';
import 'package:aaele/models/report_model.dart';
import 'package:aaele/models/timestamps_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/home_repository.dart';


class OverallMeetingReports extends ConsumerStatefulWidget {
  final int meetId;
  const OverallMeetingReports({super.key, required this.meetId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OverallMeetingReportsState();
}

class _OverallMeetingReportsState extends ConsumerState<OverallMeetingReports> {

  List<OverallMeetingModel> reports = [];
  List<MeetingTimestampModel> meetingTimestampsData = [];

  void getMeetingTimestampsData() async {
    HomeRepository homeRepository = HomeRepository();
    meetingTimestampsData =
        await homeRepository.getMeetingTimestampsData(context, widget.meetId);
    print(meetingTimestampsData[0].timestamps.map((e) => e.reportNo));
    setState(() {});
  }

  void getOverallMeetingReport() async {
    HomeRepository homeRepository = HomeRepository();
    reports = await homeRepository.getOverallMeetingReport(context, widget.meetId);
    calculateOverallEmotionPercentage(reports[0].textEmotions, reports[0].videoEmotions, reports[0].audioEmotions);
    setState(() {});
  }

  String finalOverallName = "";
  double finalOverallPercentage = 0.0;
  void calculateOverallEmotionPercentage(List<Emotion> textEmotions, List<Emotion> videoEmotions, List<Emotion> audiEmotions) {
    double maxValue = 0;
    int maxIndex = -1;
    int totalValue = 0;
    List<double> value = [
      textEmotions[0].happy + videoEmotions[0].happy + audiEmotions[0].happy ,
      textEmotions[0].surprised + videoEmotions[0].surprised + audiEmotions[0].surprised,
      textEmotions[0].confused + videoEmotions[0].confused + audiEmotions[0].confused,
      textEmotions[0].bored + videoEmotions[0].bored + audiEmotions[0].bored,
      textEmotions[0].pnf + videoEmotions[0].pnf + audiEmotions[0].pnf
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
        finalOverallName = "Happy";
        break;
      case 1:
        finalOverallName = "Surprised";
        break;
      case 2:
        finalOverallName = "Confused";
        break;
      case 3:
        finalOverallName = "Bored";
        break;
      case 4:
        finalOverallName = "Person Not Found";
        break;
      default:
        break;
    }
    finalOverallPercentage = (maxValue / totalValue) * 100;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOverallMeetingReport();
    getMeetingTimestampsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Class seems to be $finalOverallName in this lecture",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "$finalOverallName: ${finalOverallPercentage.round()}%",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Last 5 minutes",
                    style: TextStyle(fontSize: 15, color: Colors.blue.shade200)),
              ),
              const SizedBox(height: 50),
              reports.isEmpty
                  ? Center(child: const CircularProgressIndicator())
                  : ((reports[0].textEmotions[0].bored == 0 &&
                          reports[0].textEmotions[0].happy == 0 &&
                          reports[0].textEmotions[0].confused == 0 &&
                          reports[0].textEmotions[0].surprised == 0 &&
                          reports[0].textEmotions[0].pnf == 0)
                      ? NoDataFound(emotionName: "Text Emotion")
                      : PieChartWidget(
                          emotionName: "Text Emotion",
                          emotions: reports[0].textEmotions,
                          sectionIndex: 0)),
              const SizedBox(height: 20),
              reports.isEmpty
                  ? Center(child: const CircularProgressIndicator())
                  : ((reports[0].videoEmotions[0].bored == 0 &&
                          reports[0].videoEmotions[0].happy == 0 &&
                          reports[0].videoEmotions[0].confused == 0 &&
                          reports[0].videoEmotions[0].surprised == 0 &&
                          reports[0].videoEmotions[0].pnf == 0)
                      ? NoDataFound(emotionName: "Video Emotion")
                      : PieChartWidget(
                          emotionName: "Video Emotion",
                          emotions: reports[0].videoEmotions,
                          sectionIndex: 1)),
              const SizedBox(height: 20),
              reports.isEmpty
                  ? Center(child: const CircularProgressIndicator())
                  : ((reports[0].audioEmotions[0].bored == 0 &&
                          reports[0].audioEmotions[0].happy == 0 &&
                          reports[0].audioEmotions[0].confused == 0 &&
                          reports[0].audioEmotions[0].surprised == 0 &&
                          reports[0].audioEmotions[0].pnf == 0)
                      ? NoDataFound(emotionName: "Text Emotion")
                      : PieChartWidget(
                          emotionName: "Audio Emotion",
                          emotions: reports[0].audioEmotions,
                          sectionIndex: 2)),
              const SizedBox(height: 20),
              meetingTimestampsData.isEmpty
                  ? Center(child: const CircularProgressIndicator())
                  :  ((meetingTimestampsData[0].timestamps.length == 0) ? NoDataFound(emotionName: "Text Emotion") : MultiLineBarWidget(timestamps: meetingTimestampsData[0].timestamps, modeType: "Text Emotion")),
              const SizedBox(height: 20),
              meetingTimestampsData.isEmpty
                  ? Center(child: const CircularProgressIndicator())
                  : ((meetingTimestampsData[1].timestamps.length == 0) ? NoDataFound(emotionName: "Video Emotion") : MultiLineBarWidget(timestamps: meetingTimestampsData[1].timestamps, modeType: "Video Emotion")),
              const SizedBox(height: 20),
              meetingTimestampsData.isEmpty
                  ? Center(child: const CircularProgressIndicator())
                  :  ((meetingTimestampsData[2].timestamps.length == 0) ? NoDataFound(emotionName: "Audio Emotion") : MultiLineBarWidget(timestamps: meetingTimestampsData[2].timestamps, modeType: "Audio Emotion")),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}