import 'package:app_for_security/services/auth.dart';
import 'package:app_for_security/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:app_for_security/user.dart';
import 'package:provider/provider.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper()
      ),
    );
  }
}



