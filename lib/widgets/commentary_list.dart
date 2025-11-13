// lib/widgets/commentary_list.dart
import 'package:flutter/material.dart';

class CommentaryList extends StatelessWidget {
  final List<String> commentary;

  const CommentaryList({Key? key, required this.commentary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (commentary.isEmpty) {
      return Center(child: Text("No commentary available yet"));
    }

    return Card(
      margin: EdgeInsets.all(10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: commentary.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.sports_cricket, color: Colors.orange),
            title: Text(commentary[index]),
          );
        },
      ),
    );
  }
}
