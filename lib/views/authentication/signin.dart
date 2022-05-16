import 'package:billshare/services/auth_service.dart';
import 'package:billshare/views/authentication/components/rounded_button.dart';
import 'package:billshare/views/shared/loading.dart';
import 'package:flutter/material.dart';
import "package:billshare/constants.dart";

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? const Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.3,
                    ),
                    const Text(
                      "Bill Share",
                      style: TextStyle(
                          fontFamily: "DancingScript",
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() => email = value);
                        },
                        validator: (val) => (val != null && val.isEmpty)
                            ? 'Enter an email'
                            : null,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                          hintText: "Your Email",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                          setState(() => password = value);
                        },
                        validator: (val) => (val != null && val.length < 6)
                            ? "Enter password of 6+ chars long"
                            : null,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          hintText: "Password",
                          icon: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    RoundedButton(
                      text: "Login",
                      press: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null || result.uid == "") {
                            setState(() {
                              loading = false;
                              error =
                                  'Could not sign in with those credentials';
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Don’t have an Account ? ",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        GestureDetector(
                          onTap: () => widget.toggleView(),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // TextButton(
                        //   style: TextButton.styleFrom(
                        //     textStyle: const TextStyle(color: kPrimaryColor),
                        //   ),
                        //   onPressed: () => widget.toggleView,
                        //   child: const Text('Sign Up'),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
