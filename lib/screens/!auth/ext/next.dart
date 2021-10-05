import 'package:flutter/material.dart';

class Next extends StatefulWidget {
  const Next({Key? key}) : super(key: key);

  @override
  _NextState createState() => _NextState();
}

class _NextState extends State<Next> {
  Widget _bottomNav(context) {
    return Row(
      children: const [
        Text('Next Bottom Nav'),
      ],
    );
  }

  Widget _bodyContent(context) {
    return Column(
      children: const [
        Text('Next Body context'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
