import 'package:app_for_security/user_area/control_panel.dart';
import 'package:flutter/material.dart';
import 'package:app_for_security/user_area/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:app_for_security/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    //Return either Panel() or Login() widget
    if(user == null)
      return Login();
    else return Panel();
  }
}
