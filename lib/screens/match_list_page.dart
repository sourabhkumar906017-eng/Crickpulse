import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MatchListPage extends StatefulWidget {
  @override
  _MatchListPageState createState() => _MatchListPageState();
}

class _MatchListPageState extends State<MatchListPage> {
  final ApiService apiService = ApiService();
  List<dynamic> matches = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    loadMatches();
  }

  void loadMatches() async {
    try {
      var data = await apiService.fetchMatches();
      setState(() {
        matches = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Matches")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          var match = matches[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(match['name'] ?? "No Name"),
              subtitle: Text(match['status'] ?? ""),
              trailing: Text(match['matchType'] ?? ""),
            ),
          );
        },
      ),
    );
  }
}