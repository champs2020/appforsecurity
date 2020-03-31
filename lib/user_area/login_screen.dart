import 'package:app_for_security/services/auth.dart';
import 'package:app_for_security/shared/loading.dart';
import 'package:app_for_security/shared/constants.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formkey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool loading = false;

  String email = '';
  String password = '';
  String error= '';

  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('PandaZone Solutions'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child:
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty? 'Digite seu email': null,
                    onChanged: (val){
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Senha'),
                    obscureText: true,
                    validator: (val) => val.length < 6 ? 'Digite sua enha': null,
                    onChanged: (val){
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                      color: Colors.pink,
                      child: Text('Entrar',style: TextStyle(color: Colors.white,fontSize: 15)),
                      onPressed: () async{
                        if(_formkey.currentState.validate()){
                          setState(() => loading = true);
                          dynamic result = await _auth.SignInUser(email, password);

                          if(result == null) {
                            setState(() {
                              loading = false;
                              error = 'Credenciais inválidas';
                            });
                          }
                        }
                      }
                      ),
                  SizedBox(height: 12),
                  Text(
                      error,
                      style:
                        TextStyle(color: Colors.pink,fontSize: 14)
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}
