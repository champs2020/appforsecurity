import 'package:app_for_security/services/realtime_firestore_db.dart';
import 'package:app_for_security/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create a user obj based on Firebase
  User _userFromFirebase(FirebaseUser user){
    return user != null? User(uid: user.uid): null;
  }

  // stream of user uid
  Stream<User> get user{
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebase(user));
          .map(_userFromFirebase);
  }

  // sign in with email and password
  Future signInUser(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword
        (email: email,password: password);
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
}

  // sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  // authorized editor can create a new user
  Future createUser(String email, String password, bool autorizacao,
      String morador, String residencia, String condominio) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      FirebaseUser user = result.user;

      //create a new document for the user with the uid
      await Database(uid: user.uid).updateUserData(morador, autorizacao, residencia, condominio);

      return _userFromFirebase(user);
    }catch(e){
      print(e);
    }
  }

  // delete user
  Future<void> deleteUser() async{
    try{
      FirebaseUser user = await _auth.currentUser();
      user.delete();
    }catch(e){
      print(e);
    }

  }


}