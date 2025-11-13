import 'package:flutter/material.dart';
import '../models/match_model.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;

  const MatchCard({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(match.t1 + " vs " + match.t2),
        subtitle: Text(match.status),
      ),
    );
  }
}
