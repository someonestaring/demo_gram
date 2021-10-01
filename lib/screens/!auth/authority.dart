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
          'Country Selector: Handled Internally',
          style: TextStyle(color: Colors.white70),
        ),
      ),
      preferredSize: Size(size.width, size.height * 0.15),
    );
  }

  Widget _bodyContent(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
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
                    .login(
                        permissions: ['public_profile', 'email', 'user_link']);
                final OAuthCredential fbAuthCred =
                    FacebookAuthProvider.credential(
                        loginResult.accessToken!.token);
                return _auth.signInWithCredential(fbAuthCred).then((value) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const Utility()));
                });
                // await FacebookAuth.instance.login(permissions: [
                //   'public_profile',
                //   'email',
                //   'user_link'
                // ]).then((value) {
                //   FacebookAuth.instance.getUserData().then((data) {
                //     print(data);
                //   });
                // });
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: Colors.black,
      body: _bodyContent(context),
      bottomNavigationBar: _bottomNav(context),
    );
  }
}

                    // AppStateWidget.of(context).updateUserData({
                    //   'email': data['email'],
                    //   'profilePhoto': data['picture']['url'],
                    //   'firstName': data['name'].toString().split(' ')[0],
                    //   'lastName': data['name'].toString().split(' ')[1],
                    //   "lastActive": DateTime.now(),
                    //   'username': data['name'],
                    // });