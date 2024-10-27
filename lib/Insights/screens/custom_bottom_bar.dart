import 'package:aaele/classroom/screens/chatbot.dart';
import 'package:aaele/profile/screens/lectures_display_screen.dart';
import 'package:aaele/classroom/screens/classroom_screen.dart';
import 'package:aaele/Insights/screens/attendance_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBottomBar extends ConsumerStatefulWidget {
  const CustomBottomBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomBottomBarState();
}

class _CustomBottomBarState extends ConsumerState<CustomBottomBar> {
  int _page = 0;

  var screens = [
    const ClassroomScreen(),
    const LecturesDisplayScreen(),
    const AttendanceScreen(),
  ];

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_page],
      bottomNavigationBar: CupertinoTabBar(
        height: 60,
        border: const Border(top: BorderSide.none),
        activeColor: Colors.blue.shade800,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Classroom"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _page,
        onTap: onPageChange,
      ),
    );
  }
}
