import 'package:demo_gram/screens/!auth/authority.dart';
import 'package:demo_gram/screens/auth/utility.dart';
import 'package:demo_gram/state/app_state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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
  bool _init = false;
  bool _err = false;

  void initFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _init = true;
      });
    } catch (e) {
      setState(() {
        _err = true;
      });
    }
  }

  _userSignIn() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot _userData = await _dB
          .collection('users')
          .doc(_auth.currentUser!.phoneNumber)
          .get();
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
              'tokens': FieldValue.arrayUnion([_token]),
            });
          }
        } else {
          res.reference.update({
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
    initFire();
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
    return const Text('Splash Screen');
  }
}
