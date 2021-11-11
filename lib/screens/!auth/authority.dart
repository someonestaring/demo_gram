import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_gram/screens/!auth/ext/man_reg.dart';
import 'package:demo_gram/screens/auth/utility.dart';
import 'package:demo_gram/state/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demo_gram/screens/!auth/ext/login.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Authority extends StatelessWidget {
  const Authority({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _dB = FirebaseFirestore.instance;
    PreferredSizeWidget _appBar() {
      final Size size = MediaQuery.of(context).size;
      return PreferredSize(
        child: const Center(
          child: Text(
            'Country Selector: Handled Internally',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        preferredSize: Size(size.width, size.height * 0.15),
      );
    }

    Widget _bodyContent() {
      Map _userData = AppStateScope.of(context).userData;
      Size size = MediaQuery.of(context).size;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            Text(
              'Demo_Gram',
              style: GoogleFonts.dancingScript(
                textStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 42.0,
                    // wordSpacing: 0.75,
                    fontWeight: FontWeight.w900),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            SizedBox(
              width: size.width,
              child: ElevatedButton(
                onPressed: () async {
                  final LoginResult loginResult = await FacebookAuth.instance
                      .login(permissions: [
                    'public_profile',
                    'email',
                    'user_link'
                  ]);
                  final OAuthCredential fbAuthCred =
                      FacebookAuthProvider.credential(
                          loginResult.accessToken!.token);
                  return _auth.signInWithCredential(fbAuthCred).then((value) {
                    print('User Info ---------> ${value.user}');
                    User? data = value.user;
                    AppStateWidget.of(context).updateUserData({
                      'email': data!.email,
                      'profilePhoto': data.photoURL,
                      'fullName': data.displayName,
                      'firstName': data.displayName.toString().split(' ')[0],
                      'lastName': data.displayName.toString().split(' ')[1],
                      "lastActive": DateTime.now(),
                      'username': data.displayName,
                    });
                    _dB.collection("users").doc(_auth.currentUser!.uid).set({
                      'email': _userData['email'],
                      'profilePhoto': _userData['profilePhoto'],
                      'fullName': _userData['fullName'],
                      'firstName': _userData['firstName'],
                      'lastName': _userData['lastName'],
                      'lastActive': DateTime.now(),
                      'username': _userData['username'],
                    });
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => const Utility()));
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.facebook, color: Colors.white),
                    Text('Login with Facebook')
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Divider(
                      color: Colors.white70,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const ManualRegister()));
              },
              child: Text(
                'Sign up with email or phone number',
                style: TextStyle(
                    color: Colors.blue[300], fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      );
    }

    Widget _bottomNav() {
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

    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.black,
      body: _bodyContent(),
      bottomNavigationBar: _bottomNav(),
    );
  }
}
