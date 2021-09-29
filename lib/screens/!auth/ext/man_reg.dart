import 'package:demo_gram/screens/!auth/authority.dart';
import 'package:flutter/material.dart';

class ManualRegister extends StatefulWidget {
  const ManualRegister({Key? key}) : super(key: key);

  @override
  _ManualRegisterState createState() => _ManualRegisterState();
}

class _ManualRegisterState extends State<ManualRegister> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const Authority()));
      },
      child: const Text(
        'Manual Register Page',
        style: TextStyle(
          color: Colors.white70,
        ),
      ),
    ));
  }
}
