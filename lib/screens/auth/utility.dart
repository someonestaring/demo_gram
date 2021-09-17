import 'package:demo_gram/screens/auth/ext/home.dart';
import 'package:demo_gram/screens/auth/ext/messages.dart';
import 'package:demo_gram/state/app_state.dart';
import 'package:flutter/material.dart';

class Utility extends StatelessWidget {
  const Utility({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController _pageCont = AppStateScope.of(context).pageCont;
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: PageView(
          physics: const BouncingScrollPhysics(),
          controller: _pageCont,
          children: const [
            HomeScreen(),
            MessageScreen(),
          ],
        ),
      ),
    );
  }
}
