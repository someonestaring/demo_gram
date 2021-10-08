import 'package:flutter/material.dart';

class PostEditing extends StatefulWidget {
  const PostEditing({Key? key}) : super(key: key);

  @override
  _PostEditingState createState() => _PostEditingState();
}

class _PostEditingState extends State<PostEditing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('GoBackToDemo'),
        ),
      ),
    );
  }
}
