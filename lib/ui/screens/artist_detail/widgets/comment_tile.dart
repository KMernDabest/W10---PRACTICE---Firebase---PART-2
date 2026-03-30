import 'package:flutter/material.dart';
import '../../../../model/comment/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(Icons.comment, color: Colors.grey),
          title: Text(comment.text),
          subtitle: Text(
            '${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
