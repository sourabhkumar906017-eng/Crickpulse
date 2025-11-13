import 'package:flutter/material.dart';

class MatchDetailPage extends StatelessWidget {
  final Map<String, dynamic> matchData;
  const MatchDetailPage({required this.matchData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final team1 = matchData['teamInfo']?[0]?['name'] ?? 'Team A';
    final team2 = matchData['teamInfo']?[1]?['name'] ?? 'Team B';
    final team1Logo = matchData['teamInfo']?[0]?['img'];
    final team2Logo = matchData['teamInfo']?[1]?['img'];
    final venue = matchData['venue'] ?? 'Unknown';
    final date = matchData['date'] ?? 'Unknown';
    final matchType = matchData['matchType'] ?? 'Unknown';
    final status = matchData['status'] ?? 'No status';
    final scores = matchData['score'] ?? [];
    final fantasy = matchData['fantasyEnabled'] == true;
    final matchStarted = matchData['matchStarted'] == true;
    final matchEnded = matchData['matchEnded'] == true;

    return Scaffold(
      appBar: AppBar(title: Text("$team1 vs $team2")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    if (team1Logo != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(team1Logo),
                        radius: 30,
                      ),
                    const SizedBox(height: 8),
                    Text(team1, style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                const Text("vs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Column(
                  children: [
                    if (team2Logo != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(team2Logo),
                        radius: 30,
                      ),
                    const SizedBox(height: 8),
                    Text(team2, style: const TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Venue: $venue"),
            Text("Date: $date"),
            Text("Match Type: $matchType"),
            Text("Status: $status",
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.deepPurple)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: [
                if (fantasy) const Chip(label: Text("Fantasy Enabled"), backgroundColor: Colors.green, labelStyle: TextStyle(color: Colors.white)),
                if (matchStarted) const Chip(label: Text("Match Started"), backgroundColor: Colors.orange, labelStyle: TextStyle(color: Colors.white)),
                if (matchEnded) const Chip(label: Text("Match Ended"), backgroundColor: Colors.red, labelStyle: TextStyle(color: Colors.white)),
              ],
            ),
            const Divider(height: 30),
            const Text("Scores:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...scores.map<Widget>((s) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(s['inning'] ?? 'Unknown Inning'),
                  subtitle: Text("Runs: ${s['r']} | Wickets: ${s['w']} | Overs: ${s['o']}"),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}