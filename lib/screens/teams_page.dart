import 'package:flutter/material.dart';
import 'team_detail_page.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

  // --- Demo team data ---
  final List<Map<String, dynamic>> teams = const [
    {
      'name': 'India',
      'flag': 'https://flagcdn.com/w320/in.png',
      'players': [
        'Rohit Sharma (C)',
        'Virat Kohli',
        'Shubman Gill',
        'Ravindra Jadeja',
        'Jasprit Bumrah',
        'KL Rahul',
        'Suryakumar Yadav',
        'Hardik Pandya',
        'Kuldeep Yadav',
        'Mohammed Siraj',
        'Rishabh Pant'
      ]
    },
    {
      'name': 'Australia',
      'flag': 'https://flagcdn.com/w320/au.png',
      'players': [
        'Pat Cummins (C)',
        'David Warner',
        'Steve Smith',
        'Marnus Labuschagne',
        'Mitchell Marsh',
        'Glenn Maxwell',
        'Travis Head',
        'Josh Hazlewood',
        'Mitchell Starc',
        'Alex Carey',
        'Marcus Stoinis'
      ]
    },
    {
      'name': 'England',
      'flag': 'https://flagcdn.com/w320/gb-eng.png',
      'players': [
        'Jos Buttler (C)',
        'Joe Root',
        'Ben Stokes',
        'Jonny Bairstow',
        'Harry Brook',
        'Chris Woakes',
        'Moeen Ali',
        'Mark Wood',
        'Jofra Archer',
        'Liam Livingstone',
        'Sam Curran'
      ]
    },
    {
      'name': 'Pakistan',
      'flag': 'https://flagcdn.com/w320/pk.png',
      'players': [
        'Babar Azam (C)',
        'Mohammad Rizwan',
        'Shaheen Afridi',
        'Imam-ul-Haq',
        'Haris Rauf',
        'Shadab Khan',
        'Naseem Shah',
        'Fakhar Zaman',
        'Sarfaraz Ahmed',
        'Usama Mir',
        'Iftikhar Ahmed'
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(team['flag']),
                radius: 24,
              ),
              title: Text(
                team['name'],
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TeamDetailPage(
                      teamName: team['name'],
                      players: team['players'],
                      flagUrl: team['flag'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}