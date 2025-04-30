import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<User?> register(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// class AuthService {
//   Future<bool> signIn(String email, String password) async {
//     await Future.delayed(const Duration(seconds: 1));
//     return true;
//   }

//   Future<bool> register(String email, String password) async {
//     await Future.delayed(const Duration(seconds: 1));
//     return true;
//   }

//   Future<void> resetPassword(String email) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//   }

//   Future<void> signOut() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//   }
// }
