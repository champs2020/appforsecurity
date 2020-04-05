import 'package:app_for_security/services/realtime_firestore_db.dart';
import 'package:app_for_security/user_area/finger_recognition.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:app_for_security/services/auth.dart';
import 'package:local_auth_device_credentials/local_auth.dart';
import 'package:provider/provider.dart';

import '../user.dart';
class Panel extends StatefulWidget {
  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {

  final AuthService _auth = AuthService();
  final Fingerprint _fingerprint = Fingerprint();

  bool checkBiometric;
  List<BiometricType> availableBiometrics;
  bool command1 = false;
  bool command2 = false;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            StreamBuilder<UserData>(
            stream: Database(uid: user.uid).userData,
            builder: (context,snapshot) {
              if (snapshot.hasData) {
                UserData userData = snapshot.data;
                bool authorized = userData.autorizacao;

                var refGate = FirebaseDatabase.instance.reference().child(userData.condominio);

                return authorized? Column(
                  children: <Widget>[
                    StreamBuilder(
                      stream: refGate.onValue,
                      builder: (context, snap){
                        if(snap.hasData){
                          Map states = snap.data.snapshot.value;
                          states['p1'] == 1? command1 = true: command1 = false;
                          states['p2'] == 1? command2 = true: command2 = false;
                          print(command1);
                          return  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              command1 == true? SizedBox(height: 80, width: 130,child: Center(child: CircularProgressIndicator())): RaisedButton(
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: SizedBox(height: 60, width: 125,
                                      child: Center(
                                          child: Text(
                                              command1? 'Confirmando...':'Portão de pessoal',
                                              style: TextStyle(color: Colors.white, fontSize: 18,
                                                  fontWeight: FontWeight.bold)))),
                                  onPressed: () async {
                                    dynamic biometric = await _fingerprint.authenticate();
                                    if(biometric) {
                                      Database().updateGate(userData.condominio, 'p1', 1);
                                      command1 = true;
                                    } //else msgPortao = 'Biométria cancelada' ;

                                  }
                              ),
                              SizedBox(width: 10),
                              command2? SizedBox(height: 80, width: 130,child: Center(child: CircularProgressIndicator())):RaisedButton(
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: SizedBox(height: 60, width: 125,
                                      child: Center(
                                          child: Text(command2? 'Confirmando...':'Portão de veículo',
                                              style: TextStyle(color: Colors.white, fontSize: 18,
                                                  fontWeight: FontWeight.bold)))),
                                  onPressed: () async {
                                    dynamic biometric = await _fingerprint.authenticate();
                                    if(biometric) {
                                      Database().updateGate(userData.condominio, 'p2', 1);
                                      command2 = true;
                                    }//else msgPortao = 'Biométria cancelada' ;

                                  }
                              )
                            ],
                          );
                        } else return Text('SEM DADOS');
                      },
                    ),
                  ],
                ): Text('Usuário Nâo tem autorização para efetuar comando');
              } else return Text('');

            }
            ),
            SizedBox(height: 20),
          ],
        ),
      );
  }
}
