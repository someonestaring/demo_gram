import 'package:demo_gram/screens/!auth/authority.dart';
import 'package:demo_gram/screens/!auth/ext/login.dart';
import 'package:flutter/material.dart';

class ManualRegister extends StatefulWidget {
  const ManualRegister({Key? key}) : super(key: key);

  @override
  _ManualRegisterState createState() => _ManualRegisterState();
}

class _ManualRegisterState extends State<ManualRegister> {
  bool _methodType = false;

  Widget _bottomNav(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const Login()));
          },
          child: const Text(
            'Log in.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget _bodyContent(context) {
    Size size = MediaQuery.of(context).size;
    return !_methodType
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _methodType = !_methodType;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Email/Phone ??'),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const Authority()));
                },
                child: const Text(
                  'Phone Register Page',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _methodType = !_methodType;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Email/Phone ??'),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const Authority()));
                },
                child: const Text(
                  'Email Register Page',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: _bodyContent(context),
      bottomNavigationBar: _bottomNav(context),
    );
  }
}
