import 'package:flutter/material.dart';

class ActivityBody extends StatefulWidget {
  const ActivityBody({Key? key}) : super(key: key);

  @override
  _ActivityBodyState createState() => _ActivityBodyState();
}

class _ActivityBodyState extends State<ActivityBody> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Activity Body',
      ),
    );
  }
}
