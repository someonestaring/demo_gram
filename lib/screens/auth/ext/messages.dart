import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Messages Bitch',
        style: TextStyle(
          color: Colors.white54,
        ),
      ),
    );
  }
}
