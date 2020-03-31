import 'package:app_for_security/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create a user obj based on Firebase
  User _userFromFirebase(FirebaseUser user){
    return user != null? User(uid: user.uid): null;
  }

   Future upgrade() async{
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  // stream of user uid
  Stream<User> get user{
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebase(user));
          .map(_userFromFirebase);
  }

  // sign in with email and password
  Future SignInUser(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email,password: password);
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

  Future createUser() async{

  }

  // delete user
  Future deleteUser() async{

  }


}