import 'package:demo_gram/state/app_state.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          AppStateWidget.of(context).backNav();
        },
        child: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}
