import 'package:app_for_security/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
class Database{

  String uid;
  Database({this.uid});

  final CollectionReference usersCollection = Firestore.instance.collection('usuarios');

  Future updateUserData(String nome, bool autorizacao, String residencia, String condominio) async{
    return await usersCollection.document(uid).setData({
      'nome': nome,
      'autorizacao': autorizacao,
      'residencia': residencia,
      'condominio': condominio,
      'autorizado': true
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      morador: snapshot.data['morador'],
      autorizacao: snapshot.data['autorizacao'],
      residencia: snapshot.data['residencia'],
      condominio: snapshot.data['condominio']
    );
  }

  // obtain checking authorization
  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }

  Stream<UserData> get stateGate {

  }


  //Realtime Database area

  Future updateGate (String condominio, String position, int portao) {

      return FirebaseDatabase.instance.reference().child(condominio)
          .update({ position: portao});
  }


}