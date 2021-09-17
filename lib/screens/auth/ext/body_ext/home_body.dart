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
