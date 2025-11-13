import 'package:flutter/material.dart';
import 'score_page.dart';
import 'profile_page.dart';
// import 'live_score_pages.dart';
// import 'complete_score_pages.dart';
// import 'upcoming_score_pages.dart';

class HomePage extends StatelessWidget {
  final String username;
  HomePage({required this.username});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("CrickPulse"),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(username: username)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                  child: Icon(Icons.person, color: Colors.white),
                  backgroundColor: Colors.grey.shade700,
                ),
              ),
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: "Live"),
              Tab(text: "Completed"),
              Tab(text: "Upcoming"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ScorePage(type: "live"),
            ScorePage(type: "completed"),
            ScorePage(type: "upcoming"),
          ],
        ),
      ),
    );
  }
}