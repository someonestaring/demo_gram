import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: const [
          Text('Home Body'),
          // StreamBuilder(builder: builder),
          // StreamBuilder(builder: builder),
        ],
      ),
    );
  }
}

// possible multi-picture/video post solution --> https://stackoverflow.com/questions/58088799/flutter-3d-cube-rotation-transform-matrix-like-instagram-stories