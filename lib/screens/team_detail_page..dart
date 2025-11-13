import 'package:flutter/material.dart';

class TeamDetailPage extends StatelessWidget {
  final String teamName;
  final String flagUrl;
  final List<String> players;

  const TeamDetailPage({
    super.key,
    required this.teamName,
    required this.players,
    required this.flagUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teamName),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            backgroundImage: NetworkImage(flagUrl),
            radius: 40,
          ),
          const SizedBox(height: 12),
          Text(
            teamName,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const Text(
            "Team Members",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      players[index][0],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(players[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}