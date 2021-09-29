import 'package:demo_gram/screens/!auth/ext/man_reg.dart';
import 'package:flutter/material.dart';
import 'package:demo_gram/screens/!auth/ext/login.dart';
import 'package:flutter/widgets.dart';
// import com.facebook.FacebookSdk;
// import 'com.facebook.appevents.AppEventsLogger';

class Authority extends StatelessWidget {
  const Authority({Key? key}) : super(key: key);

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

  PreferredSizeWidget _appBar(context) {
    final Size size = MediaQuery.of(context).size;
    return PreferredSize(
      child: const Center(
        child: Text(
          'Country Selector',
          style: TextStyle(color: Colors.white70),
        ),
      ),
      preferredSize: Size(size.width, size.height * 0.015),
    );
  }

  Widget _bodyContent(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Demo_Gram',
            style: TextStyle(color: Colors.white70),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'OR',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const ManualRegister()));
            },
            child: const Text(
              'Sign up with email or phone number',
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: Colors.black,
      body: _bodyContent(context),
      bottomNavigationBar: _bottomNav(context),
    );
  }
}
