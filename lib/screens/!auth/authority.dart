import 'package:firebase_auth/firebase_auth.dart';
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
  var _verId;

  @override
  void dispose() {
    _numCont.dispose();
    _passCont.dispose();
    _smsCont.dispose();
    super.dispose();
  }

  void _logIn() async {
    String? _showSMS(context) {
      String? res;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
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
                        }
                        return value;
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    res = _smsCont.text;
                    print('this is the sms code user input: ${_smsCont.text}');
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
      return res;
    }

    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    await _auth.verifyPhoneNumber(
      phoneNumber: '+1${_numCont.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        String? smsCode = _showSMS(context);
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: _verId, smsCode: smsCode!);
        await _auth.signInWithCredential(credential);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const Utility()));
      },
      verificationFailed: (FirebaseAuthException e) {
        print('The verification failed due to: $e');
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          _verId = verificationId;
        });
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    print('Make the shit log in you idiot: ${_numCont.text} --> ');
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
          )
        ],
      )),
    );
  }
}
