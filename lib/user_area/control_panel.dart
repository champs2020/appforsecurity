import 'package:app_for_security/user_area/finger_recognition.dart';
import 'package:flutter/material.dart';
import 'package:app_for_security/services/auth.dart';
import 'package:local_auth_device_credentials/local_auth.dart';
class Panel extends StatefulWidget {
  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {

  final AuthService _auth = AuthService();
  final Fingerprint _fingerprint = Fingerprint();

  bool checkBiometric;
  List<BiometricType> availableBiometrics;
  String authorized = 'Not Authorized';
  bool isAuthenticating = false;
  bool authenticated = false;

  @override
  Widget build(BuildContext context) {



    //User atu = AuthService().user;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Área do usuário',style: TextStyle(color: Colors.white,fontSize: 25)),
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.perm_identity),
              label: Text('Sair'),
            onPressed: () async{
                await _auth.signOut();
            },
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /*Text('Can check biometrics: $checkBiometric\n'),
                RaisedButton(
                  child: Text('Check biometrics'),
                  onPressed: () async{
                    dynamic result = await _fingerprint.checkBiometrics();
                    setState(() => checkBiometric = result);
                  },
                ),*/
               // Text('Available biometrics: $_availableBiometrics\n'),
                /*RaisedButton(
                  child: Text('Get available biometrics: $availableBiometrics'),
                    onPressed: () async{
                    dynamic result = await _fingerprint.getAvailableBiometrics();
                    setState(() => availableBiometrics = result);
                    },
                ),
                Text('Current State: $authenticated\n'),
                */
                RaisedButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: SizedBox(height: 100,width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(isAuthenticating ? 'Confirmando...' : '\tAbrir Portão',
                              style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold))),
                      )),
                  onPressed:() async {
                    dynamic results = await AuthService().upgrade();
                    //dynamic results = await _auth.SignInUser('champs@gmail.com', '123456');
                    if (results != null) {
                      print(results);
                      setState(() {
                        isAuthenticating = true;
                        authorized = 'Authenticating';
                      });
                      dynamic result = await _fingerprint.authenticate();
                      setState(() {
                        authenticated = result;
                        isAuthenticating = false;
                        authorized =
                        authenticated ? 'Authorized' : 'Not Authorized';
                      });
                    }
                  }
                ),
                SizedBox(height: 10)
              ]),
        ],
      ),
    );
  }
}
