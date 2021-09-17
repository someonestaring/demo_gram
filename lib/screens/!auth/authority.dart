import 'package:demo_gram/state/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:demo_gram/screens/auth/utility.dart';

class Authority extends StatefulWidget {
  const Authority({Key? key}) : super(key: key);
  @override
  _AuthorityState createState() => _AuthorityState();
}

class _AuthorityState extends State<Authority> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _smsKey = GlobalKey<FormState>();
  final TextEditingController _numCont = TextEditingController();
  final TextEditingController _passCont = TextEditingController();
  final TextEditingController _smsCont = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  PhoneAuthCredential? _authCredential;
  String? phoneNumber;
  bool verification = false;
  bool isActive = false;
  bool loading = false;
  String? _smsCode;
  String? _verId;

  @override
  void initState() {
    super.initState();
    _numCont.addListener(_handleInput);
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    _numCont.dispose();
    _passCont.dispose();
    _smsCont.dispose();
    super.dispose();
  }

  void _handleInput() {
    setState(() {
      phoneNumber = '+1${_numCont.text}';
    });
  }

  void _codeSent(String verificationId, int? resendToken) async {
    _showSMS(context);
    setState(() {
      loading = false;
      verification = true;
      _verId = verificationId;
    });
  }

  void _veriFailed(FirebaseAuthException e) {
    print('Verification FAILURE due to: $e');
  }

  void _veriCompleted(PhoneAuthCredential credential) async {
    try {
      setState(() {
        _authCredential = credential;
      });
      UserCredential user = await _auth.signInWithCredential(_authCredential!);
      if (user.user != null) {
        _store.collection("users").doc(user.user!.phoneNumber).update({
          "phoneNumber": user.user!.phoneNumber,
          'lastActive': DateTime.now(),
          'uId': user.user!.uid,
        });
        AppStateWidget.of(context).updateUserData({
          'phoneNumber': user.user!.phoneNumber,
          'lastActive': DateTime.now(),
          'uId': user.user!.uid,
        });
        print('User signed in, time to navigatge');
      }
    } catch (e) {
      print('_veriCompleted error: $e');
    }
  }

  void _autoRetrieval(String verificationId) {
    print('code auto-retrieval timeout --> verificationId --> $verificationId');
  }

  void _showSMS(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 3,
            actionsAlignment: MainAxisAlignment.center,
            scrollable: true,
            title: const Text('SMS Code:'),
            content: Form(
              key: _smsKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _smsCont,
                    style: const TextStyle(color: Colors.white38),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintStyle: const TextStyle(color: Colors.white38),
                      hintText: 'SMS Code',
                    ),
                    validator: (String? value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(RegExp('[a-zA-Z]')) ||
                          value.length != 6) {
                        return 'Please use only 6 numbers';
                      } else {
                        setState(() {
                          _smsCode = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    _smsCode = _smsCont.text;
                  });
                  _continueRegistration();
                  print('this is the return string from _showSMS: $_smsCode');
                  Navigator.of(context).pop();
                  _smsCont.clear();
                  _numCont.clear();
                  _passCont.clear();
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
  }

  Future<void> _continueRegistration() async {
    try {
      UserCredential? user = await _auth.signInWithCredential(_authCredential!);
      var boof = user.user;
      if (boof != null) {
        _store.collection("users").doc(user.user!.phoneNumber).set({
          "phoneNumber": user.user!.phoneNumber,
          'lastActive': DateTime.now(),
          'uId': user.user!.uid,
        });
        AppStateWidget.of(context).updateUserData({
          'phoneNumber': user.user!.phoneNumber,
          'lastActive': DateTime.now(),
          'uId': user.user!.uid,
        });
        print('User signed in, time to navigatge');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Utility()));
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print('Error on _continueRestistration. $e');
    }
  }

  void _logIn() async {
    setState(() {
      loading = true;
    });
    if (!verification) {
      await _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: phoneNumber!,
        verificationCompleted: _veriCompleted,
        verificationFailed: _veriFailed,
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _autoRetrieval,
      );
    } else {
      setState(() {
        _authCredential = PhoneAuthProvider.credential(
            verificationId: _verId!, smsCode: _smsCode!);
      });
      _continueRegistration();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: ,
      backgroundColor: Colors.black38,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _numCont,
                    style: const TextStyle(color: Colors.white38),
                    decoration: InputDecoration(
                      // prefixText: '+1',
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintStyle: const TextStyle(color: Colors.white38),
                      hintText: 'Phone Number',
                    ),
                    validator: (String? value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(RegExp('[a-zA-Z]'))) {
                        return 'Please use only numbers';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passCont,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white38),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      alignLabelWithHint: true,
                      hintStyle: const TextStyle(color: Colors.white38),
                      hintText:
                          'Faux Password', // not set up --> condition _numCont TFF to accept emails blah blah blah
                      suffixIcon: const Icon(
                        Icons.visibility_off,
                        color: Colors.white38,
                      ),
                    ),
                    validator: (String? value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please enter some text';
                      // }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          _logIn();
                        }
                      },
                      child: const Text('Log In'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Row(
          //   children: const [
          //     SizedBox(
          //       width: size.width * 0.28,
          //       child: DecoratedBox(
          //         decoration: BoxDecoration(
          //           border: Border(
          //             bottom: BorderSide(
          //               color: Colors.white54,
          //               width: 2,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      )),
    );
  }
}
