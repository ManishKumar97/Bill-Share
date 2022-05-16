import 'package:billshare/services/auth_service.dart';
import 'package:billshare/views/authentication/components/rounded_button.dart';
import "package:billshare/constants.dart";
import 'package:billshare/views/shared/loading.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  const SignUp({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  // text field state
  String name = '';
  String email = '';
  String password = '';
  String retypePassword = '';

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.12,
                    ),
                    const Text(
                      "Bill Share",
                      style: TextStyle(
                          fontFamily: "DancingScript",
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    const Text(
                      "Welcome!",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() => name = value);
                        },
                        validator: (val) => (val != null && val.isEmpty)
                            ? 'Enter valid name'
                            : null,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                          hintText: "Your name",
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
                        borderRadius: BorderRadius.circular(29),
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
                        borderRadius: BorderRadius.circular(29),
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
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                          setState(() => retypePassword = value);
                        },
                        validator: (val) {
                          if (val != password) {
                            return "Password mismatch";
                          } else {
                            return null;
                          }
                        },
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          hintText: "Retype Password",
                          icon: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    RoundedButton(
                        text: "Register",
                        press: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    name, email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Please supply a valid email';
                              });
                            }
                          }
                        }),
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
                          "Already have an Account ? ",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        GestureDetector(
                          onTap: () => widget.toggleView(),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
