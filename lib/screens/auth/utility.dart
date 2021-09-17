import 'package:demo_gram/screens/auth/ext/home.dart';
import 'package:demo_gram/screens/auth/ext/messages.dart';
import 'package:flutter/material.dart';

class Utility extends StatelessWidget {
  Utility({Key? key}) : super(key: key);
  final PageController _pageCont = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: PageView(
          physics: const BouncingScrollPhysics(),
          controller: _pageCont,
          children: [
            HomeScreen(
              pageCont: _pageCont,
            ),
            MessageScreen(
              pageCont: _pageCont,
            ),
          ],
        ),
      ),
    );
  }
}
