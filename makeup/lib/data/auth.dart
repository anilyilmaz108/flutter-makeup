import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth{
  final _firebaseAuth = FirebaseAuth.instance;

  Future<User> signInAnonymously() async {
    try {
      final UserCredential userCredentials =
      await _firebaseAuth.signInAnonymously();
      return userCredentials.user;
    } catch (_) {
      rethrow;
    }
  }

  Future<User> CreateUserWithEmailAndPassword(String email, String password)async{

    UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;

    } on FirebaseAuthException catch(e){
      print(e.code);
      print(e.message);
      rethrow;
    }


  }

  Future<User> signInWithEmailAndPassword(String email, String password)async{
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<void> sendPasswordResetEmail(String email)async{
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }



  Future<User> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    if(googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
      await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    }
    else{
      return null;
    }
  }



  Future<User>SignOut()async{
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  Stream<User>authStatus(){
    return _firebaseAuth.authStateChanges();
  }

}