import 'package:aaele/Insights/repository/home_repository.dart';
import 'package:aaele/auth/screens/login_screen.dart';
import 'package:aaele/classroom/screens/new_chat_bot.dart';
import 'package:aaele/classroom/widgets/subject_card.dart';
import 'package:aaele/constants/constants.dart';
import 'package:aaele/models/meeting_model.dart';
import 'package:aaele/quiz/screens/quiz_rules_screen.dart';
import 'package:aaele/quiz/screens/take_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturesDisplayScreen extends ConsumerStatefulWidget {
  const LecturesDisplayScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LecturesDisplayScreenState();
}

class _LecturesDisplayScreenState extends ConsumerState<LecturesDisplayScreen> {
  List<MeetingModel> allMeetings = [];
  String? userName = "";

  void getAllMeetings() async {
    HomeRepository homeRepository = HomeRepository();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? studentId = prefs.getInt("student_id");
    userName = prefs.getString("name");
    // ignore: use_build_context_synchronously
    allMeetings = await homeRepository.getAllMeetings(context, studentId!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllMeetings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("name");
                prefs.remove("student_id");
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lectures",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => const InsightsScreen()));
              //   },
              //   child: const LectureCard(),
              // ),
              (allMeetings.isEmpty)
                  ? const Center(
                      child: SpinKitSpinningLines(color: Colors.blue, size: 60),
                    )
                  : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allMeetings.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // getNotesForMeeting(allMeetings[index].meetId);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TakeQuizScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: SubjectCard(
                            name: allMeetings[index].title,
                            testBy: allMeetings[index].hostName,
                            description: allMeetings[index].description,
                            lecDisplayImage: Constants.lecDisplayImage[index%3],
                            color: Constants.subjectColors[index%5],
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}