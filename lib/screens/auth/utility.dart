import 'package:flutter/material.dart';

class Utility extends StatelessWidget {
  const Utility({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text('Utility Page, Super Congrats!!'),
        ],
      ),
    );
  }
}
