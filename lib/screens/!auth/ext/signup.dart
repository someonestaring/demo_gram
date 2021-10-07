import 'package:demo_gram/screens/auth/utility.dart';
import 'package:demo_gram/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _dB = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  User? user;
  bool authed = false;
  void _userSignIn() async {
    setState(() {
      user = _auth.currentUser;
    });
    var checker = user;
    if (checker != null) {
      String? _token = await _messaging.getToken();
      await _dB
          .collection('users')
          .doc(_auth.currentUser!.uid)
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
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        _navigate(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigate(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const Utility()));
  }

  Future<void> _continueEmailSignIn(e, p) async {
    Map _userData = AppStateScope.of(context).userData;
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _userData['email'],
              password: AppStateScope.of(context).miscData['password']);
      var checker = userCredential.user;
      if (checker != null) {
        await _auth.signInWithEmailAndPassword(email: e, password: p);
        await _dB.collection("users").doc(userCredential.user!.uid).set({
          'email': _userData['email'],
          // 'profilePhoto': _userData['picture']['url'],
          'fullName': _userData['fullName'],
          "lastActive": DateTime.now(),
          'username': _userData['username'],
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map _userData = AppStateScope.of(context).userData;
    Size size = MediaQuery.of(context).size;

    Widget _bodyContent() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: size.height * 0.025,
                  left: size.width * 0.25,
                  right: size.width * 0.25),
              child: Text(
                'Sign up as ${_userData['username']}?',
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.025),
              child: const Text(
                'You can always change your username later.',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            SizedBox(
              width: size.width * 0.9,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    _continueEmailSignIn(_userData['email'],
                        AppStateScope.of(context).miscData['password']);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('Sign Up'),
              ),
            )
          ],
        ),
      );
    }

    Widget _bottomNav() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'By tapping Sign Up, you agree to our ',
            style: const TextStyle(color: Colors.white54),
            children: [
              TextSpan(
                text: 'Terms',
                style: const TextStyle(color: Colors.white),
                recognizer: TapGestureRecognizer()..onTap = () => {},
              ),
              const TextSpan(
                text: ', ',
                style: TextStyle(color: Colors.white54),
              ),
              TextSpan(
                text: 'Data Policy ',
                style: const TextStyle(color: Colors.white),
                recognizer: TapGestureRecognizer()..onTap = () => {},
              ),
              const TextSpan(
                text: 'and ',
                style: TextStyle(color: Colors.white54),
              ),
              TextSpan(
                text: 'Cookie Policy',
                style: const TextStyle(color: Colors.white),
                recognizer: TapGestureRecognizer()..onTap = () => {},
              ),
              const TextSpan(
                text: '.',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: _bodyContent(),
      bottomNavigationBar: _bottomNav(),
      backgroundColor: Colors.black,
    );
  }
}













// class SignUp extends StatelessWidget {
//   const SignUp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Map _userData = AppStateScope.of(context).userData;
//     Size size = MediaQuery.of(context).size;
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     final FirebaseFirestore _dB = FirebaseFirestore.instance;

//       void _userSignIn() async {
//     setState(() {
//       user = _auth.currentUser;
//     });
//     if (user != null) {
//       String? _token = await _messaging.getToken();
//       await _dB
//           .collection('users')
//           .doc(_auth.currentUser!.phoneNumber)
//           .get()
//           .then((res) {
//         Map<String, dynamic>? data = res.data();
//         if (data!.containsKey('tokens')) {
//           List tokens = data['tokens'];
//           if (tokens.contains(_token)) {
//             return;
//           } else {
//             res.reference.update({
//               'lastActive': DateTime.now(),
//               'tokens': FieldValue.arrayUnion([_token]),
//             });
//           }
//         } else {
//           res.reference.update({
//             'lastActive': DateTime.now(),
//             'tokens': [_token]
//           });
//         }
//         AppStateWidget.of(context).updateUserData(data);
//       });
//       setState(() {
//         user != null ? authed = true : authed = false;
//       });
//     }
//   }

//     Widget _bodyContent() {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                   bottom: size.height * 0.025,
//                   left: size.width * 0.25,
//                   right: size.width * 0.25),
//               child: Text(
//                 'Sign up as ${_userData['username']}?',
//                 style: const TextStyle(color: Colors.white, fontSize: 24),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(bottom: size.height * 0.025),
//               child: const Text(
//                 'You can always change your username later.',
//                 style: TextStyle(color: Colors.white54),
//               ),
//             ),
//             SizedBox(
//               width: size.width * 0.9,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     UserCredential userCredential = await _auth.instance
//                         .createUserWithEmailAndPassword(
//                             email: _userData['email'],
//                             password:
//                                 AppStateScope.of(context).miscData['password']);
//                   } on FirebaseAuthException catch (e) {
//                     if (e.code == 'weak-password') {
//                       print('The password provided is too weak.');
//                     } else if (e.code == 'email-already-in-use') {
//                       print('The account already exists for that email.');
//                     }
//                   } catch (e) {
//                     print(e);
//                   }
//                 },
//                 child: const Text('Sign Up'),
//               ),
//             )
//           ],
//         ),
//       );
//     }

//     Widget _bottomNav() {
//       return Padding(
//         padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
//         child: RichText(
//           textAlign: TextAlign.center,
//           text: TextSpan(
//             text: 'By tapping Sign Up, you agree to our ',
//             style: const TextStyle(color: Colors.white54),
//             children: [
//               TextSpan(
//                 text: 'Terms',
//                 style: const TextStyle(color: Colors.white),
//                 recognizer: TapGestureRecognizer()..onTap = () => {},
//               ),
//               const TextSpan(
//                 text: ', ',
//                 style: TextStyle(color: Colors.white54),
//               ),
//               TextSpan(
//                 text: 'Data Policy ',
//                 style: const TextStyle(color: Colors.white),
//                 recognizer: TapGestureRecognizer()..onTap = () => {},
//               ),
//               const TextSpan(
//                 text: 'and ',
//                 style: TextStyle(color: Colors.white54),
//               ),
//               TextSpan(
//                 text: 'Cookie Policy',
//                 style: const TextStyle(color: Colors.white),
//                 recognizer: TapGestureRecognizer()..onTap = () => {},
//               ),
//               const TextSpan(
//                 text: '.',
//                 style: TextStyle(color: Colors.white54),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     print(_userData.toString());

//     return Scaffold(
//       body: _bodyContent(),
//       bottomNavigationBar: _bottomNav(),
//       backgroundColor: Colors.black,
//     );
//   }
// }
