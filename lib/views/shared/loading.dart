import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:billshare/constants.dart";

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: SpinKitFadingCircle(
          color: kPrimaryColor,
          size: 50.0,
        ),
      ),
    );
  }
}
