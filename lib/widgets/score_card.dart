// lib/widgets/score_card.dart
import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  final String team1;
  final String team2;
  final String score1;
  final String score2;
  final String status;

  const ScoreCard({
    Key? key,
    required this.team1,
    required this.team2,
    required this.score1,
    required this.score2,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Live Score",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamColumn(team1, score1),
                Text("vs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                _buildTeamColumn(team2, score2),
              ],
            ),
            SizedBox(height: 12),
            Text(
              status,
              style: TextStyle(
                color: status.toLowerCase().contains("live")
                    ? Colors.red
                    : Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamColumn(String team, String score) {
    return Column(
      children: [
        Text(team, style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 5),
        Text(score, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
