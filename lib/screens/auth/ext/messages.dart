import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final PageController pageCont;
  const MessageScreen({Key? key, required this.pageCont}) : super(key: key);
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  void _backNav() {
    widget.pageCont.animateToPage(
      0,
      duration: const Duration(
        milliseconds: 500,
      ),
      curve: Curves.bounceInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: _backNav,
        child: const Text(
          'Messages Bitch',
          style: TextStyle(
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}
