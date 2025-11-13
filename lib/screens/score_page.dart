import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'match_detail_page.dart';

class ScorePage extends StatefulWidget {
  final String type; // "live", "completed", or "upcoming"

  const ScorePage({required this.type, Key? key}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final ApiService apiService = ApiService();

  /// demoMatches: exactly 10 items as requested
  final List<Map<String, dynamic>> demoMatches = List.generate(10, (index) {
    return {
      "teamInfo": [
        {
          "name": "Team ${index + 1}A",
          "img":
          "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_dot.svg"
        },
        {
          "name": "Team ${index + 1}B",
          "img":
          "https://upload.wikimedia.org/wikipedia/commons/5/5a/Blue_dot.svg"
        },
      ],
      "venue": "Stadium ${index + 1}",
      "date": "2025-10-${(index + 10).toString().padLeft(2, '0')}",
      "matchType": index % 2 == 0 ? "T20" : "ODI",
      "status": index % 3 == 0
          ? "Live"
          : index % 3 == 1
          ? "Upcoming"
          : "Completed",
      "fantasyEnabled": index % 2 == 0,
      "matchStarted": index % 3 == 0,
      "matchEnded": index % 3 == 2,
    };
  });

  List<dynamic> apiMatches = [];
  List<dynamic> matches = []; // final combined list (demo + api, merged)
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  /// Helper to create a unique key for a match to help deduplication.
  /// Uses team names + date + venue as a heuristic unique key.
  String _matchKey(Map<String, dynamic> m) {
    try {
      final t1 = (m['teamInfo']?[0]?['name'] ?? '').toString();
      final t2 = (m['teamInfo']?[1]?['name'] ?? '').toString();
      final date = (m['date'] ?? '').toString();
      final venue = (m['venue'] ?? '').toString();
      return '$t1|$t2|$date|$venue';
    } catch (_) {
      return m.toString();
    }
  }

  /// Merge demoMatches and apiMatches, keeping demoMatches first,
  /// then append apiMatches that are not duplicates.
  List<dynamic> _mergeMatches(
      List<Map<String, dynamic>> demo, List<dynamic> api) {
    final merged = <dynamic>[];
    final seen = <String>{};

    // Add demo first (preserve all 10)
    for (final d in demo) {
      merged.add(d);
      seen.add(_matchKey(d));
    }

    // Append API items only if their key is not already present
    for (final a in api) {
      try {
        final key = _matchKey(a as Map<String, dynamic>);
        if (!seen.contains(key)) {
          merged.add(a);
          seen.add(key);
        }
      } catch (_) {
        // if something unexpected, still add
        merged.add(a);
      }
    }

    return merged;
  }

  Future<void> fetchScores() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });

    try {
      final data = await apiService.fetchMatches(); // must return List<dynamic>
      if (data != null && data.isNotEmpty) {
        apiMatches = data;
      } else {
        apiMatches = [];
      }

      // Merge demo and api matches
      matches = _mergeMatches(demoMatches, apiMatches);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // On error, fallback to demo only but keep user informed
      matches = List<dynamic>.from(demoMatches);
      setState(() {
        isLoading = false;
        errorMsg = "API error - showing demo data";
      });

      // Show SnackBar with error message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        messenger?.showSnackBar(
          SnackBar(content: Text("Error fetching data: $e. Showing demo data.")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter matches based on widget.type (apply to combined list)
    final filteredMatches = matches.where((match) {
      final m = (match is Map<String, dynamic>) ? match : Map<String, dynamic>.from(match as Map);
      final bool started = (m['matchStarted'] == true);
      final bool ended = (m['matchEnded'] == true);

      if (widget.type == 'live') {
        return started == true && ended == false;
      } else if (widget.type == 'completed') {
        return ended == true;
      } else if (widget.type == 'upcoming') {
        return started == false && ended == false;
      }
      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type == 'live'
              ? "Live Matches"
              : widget.type == 'completed'
              ? "Completed Matches"
              : "Upcoming Matches",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchScores,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredMatches.isEmpty
          ? const Center(child: Text("No matches found"))
          : ListView.builder(
        itemCount: filteredMatches.length,
        itemBuilder: (context, index) {
          final match = filteredMatches[index] as Map<String, dynamic>;
          final team1 = match['teamInfo']?[0]?['name'] ?? 'Team A';
          final team2 = match['teamInfo']?[1]?['name'] ?? 'Team B';
          final team1Logo = match['teamInfo']?[0]?['img'];
          final team2Logo = match['teamInfo']?[1]?['img'];
          final venue = match['venue'] ?? 'Unknown Venue';
          final date = match['date'] ?? 'Unknown Date';
          final matchType = match['matchType'] ?? 'Unknown';
          final status = match['status'] ?? 'No Status';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MatchDetailPage(matchData: match),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (team1Logo != null)
                              CircleAvatar(
                                backgroundImage: NetworkImage(team1Logo),
                                radius: 20,
                              ),
                            const SizedBox(width: 8),
                            Text(team1,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const Text("vs"),
                        Row(
                          children: [
                            Text(team2,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(width: 8),
                            if (team2Logo != null)
                              CircleAvatar(
                                backgroundImage: NetworkImage(team2Logo),
                                radius: 20,
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("Venue: $venue"),
                    Text("Date: $date"),
                    Text("Type: $matchType"),
                    Text("Status: $status",
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.deepPurple)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (match['fantasyEnabled'] == true)
                          const Chip(
                            label: Text("Fantasy Enabled"),
                            backgroundColor: Colors.green,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        const SizedBox(width: 6),
                        if (match['matchStarted'] == true)
                          const Chip(
                            label: Text("Match Started"),
                            backgroundColor: Colors.orange,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        const SizedBox(width: 6),
                        if (match['matchEnded'] == true)
                          const Chip(
                            label: Text("Match Ended"),
                            backgroundColor: Colors.red,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
