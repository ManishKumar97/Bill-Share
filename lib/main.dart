import 'package:billshare/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:billshare/views/wrapper.dart';
import 'package:provider/provider.dart';
import "package:billshare/services/auth_service.dart";
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      initialData: AppUser(
        name: "",
        email: "",
        uid: "",
      ),
      value: AuthService().authchanges,
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
