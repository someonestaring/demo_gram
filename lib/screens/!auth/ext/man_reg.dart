import 'dart:ui';
import 'package:demo_gram/screens/!auth/ext/next.dart';
import 'package:demo_gram/screens/!auth/authority.dart';
import 'package:demo_gram/screens/!auth/ext/login.dart';
import 'package:demo_gram/state/app_state.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ManualRegister extends StatefulWidget {
  const ManualRegister({Key? key}) : super(key: key);

  @override
  _ManualRegisterState createState() => _ManualRegisterState();
}

class _ManualRegisterState extends State<ManualRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneCont = TextEditingController();
  final TextEditingController _emailCont = TextEditingController();
  List<dynamic> _countries = [];
  bool _methodType = false;

  @override
  void initState() {
    super.initState();
    _getCountries();
  }

  @override
  void dispose() {
    _phoneCont.dispose();
    _emailCont.dispose();
    super.dispose();
  }

  Future<void> _getCountries() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/countries/country_list.json');
    final List<dynamic> country_list = jsonDecode(data);
    setState(() {
      _countries = country_list;
    });
  }

  void _phoneNext(context) {
    Locale _locale = Localizations.localeOf(context);
    String? countryCode = _locale.countryCode!.toUpperCase();
    _countries.retainWhere((item) => item['code'] == countryCode);
    AppStateWidget.of(context)
        .updateUserData({'phoneNumber': '$countryCode${_phoneCont.text}'});
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => const Next()));
  }

  void _emailNext(context) {
    AppStateWidget.of(context).updateUserData({'email': _phoneCont.text});
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => const Next()));
  }

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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CircleAvatar(
            radius: 85,
            child: Icon(
              Icons.account_circle_outlined,
              color: Colors.white70,
              size: 172,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        bottom: !_methodType
                            ? const BorderSide(
                                color: Colors.white,
                                width: 2,
                              )
                            : const BorderSide(
                                color: Colors.white70,
                                width: 1,
                              ),
                      ), //EdgeInsets.only(bottom: 1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _methodType = false;
                        });
                      },
                      child: Text(
                        'Phone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_methodType ? Colors.white : Colors.white70,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        bottom: !_methodType
                            ? const BorderSide(
                                color: Colors.white70,
                                width: 1,
                              )
                            : const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                      ), //EdgeInsets.only(bottom: 1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _methodType = true;
                        });
                      },
                      child: Text(
                        'Email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !_methodType ? Colors.white70 : Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    alignLabelWithHint: true,
                    hintStyle: const TextStyle(color: Colors.white38),
                    hintText: !_methodType ? 'Phone Number' : 'Email',
                  ),
                  controller: !_methodType ? _phoneCont : _emailCont,
                  validator: !_methodType
                      ? (String? value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.contains(RegExp(r'(\D+)'))) {
                            return 'Phone Field not valid';
                          } else {
                            return null;
                          }
                        }
                      : (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Email Field not valid';
                          } else {
                            return null;
                          }
                        },
                  keyboardType: !_methodType
                      ? TextInputType.phone
                      : TextInputType.emailAddress,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: Text(
                    !_methodType
                        ? 'You may recieve SMS updates from Demo_Gram and can opt out at any time.'
                        : '',
                    style: const TextStyle(color: Colors.white54),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('Next'),
                        onPressed: () {
                          if (_formKey.currentState == null) {
                            print("_formKey.currentState is null!");
                          } else if (_formKey.currentState!.validate()) {
                            !_methodType
                                ? _phoneNext(context)
                                : _emailNext(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
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
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.02),
            child: OutlinedButton(
              style: ButtonStyle(
                  side: MaterialStateProperty.all(const BorderSide(
                      color: Colors.white70,
                      width: 1.0,
                      style: BorderStyle.solid))),
              onPressed: () {},
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.facebook,
                    ),
                    Text(
                      'Continue with Facebook',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _bodyContent(context),
      bottomNavigationBar: _bottomNav(context),
    );
  }
}
