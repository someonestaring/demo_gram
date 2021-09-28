import 'package:demo_gram/screens/!auth/authority.dart';
import 'package:demo_gram/screens/auth/utility.dart';
import 'package:demo_gram/state/app_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _dB = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  User? user;
  bool authed = false;

  void _userSignIn() async {
    setState(() {
      user = _auth.currentUser;
    });
    if (user != null) {
      String? _token = await _messaging.getToken();
      await _dB
          .collection('users')
          .doc(_auth.currentUser!.phoneNumber)
          .get()
          .then((res) {
        Map<String, dynamic>? data = res.data();
        if (data!.containsKey('tokens')) {
          List tokens = data['tokens'];
          if (tokens.contains(_token)) {
            return;
          } else {
            res.reference.update({
              'lastActive': DateTime.now(),
              'tokens': FieldValue.arrayUnion([_token]),
            });
          }
        } else {
          res.reference.update({
            'lastActive': DateTime.now(),
            'tokens': [_token]
          });
        }
        AppStateWidget.of(context).updateUserData(data);
      });
      setState(() {
        user != null ? authed = true : authed = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _userSignIn();
    _timer();
  }

  _timer() async {
    var _duration = const Duration(seconds: 5);
    return Timer(_duration, autoNav);
  }

  Future<void> autoNav() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => userAuthState(),
      ),
    );
  }

  Widget userAuthState() {
    if (!authed) {
      return const Authority();
    } else {
      return const Utility();
    }
  }

  @override
  Widget build(BuildContext context) {
    return splish();
  }
}

Widget splish() {
  return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 3,
            ),
            const Icon(
              Icons.photo_camera,
              color: Colors.white54,
              size: 62,
            ),
            const Spacer(
              flex: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text(
                  'From',
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white54,
                  ),
                ),
                Text(
                  'CHIPPERTON',
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
}
