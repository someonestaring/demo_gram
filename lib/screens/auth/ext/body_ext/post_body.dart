import 'package:flutter/material.dart';

class PostBody extends StatefulWidget {
  const PostBody({Key? key}) : super(key: key);
  @override
  _PostBodyState createState() => _PostBodyState();
}

class _PostBodyState extends State<PostBody> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Post Body, you stupid bitch',
      ),
    );
  }
}
