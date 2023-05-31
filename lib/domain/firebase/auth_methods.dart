import 'package:firebase_auth/firebase_auth.dart';
import 'package:task/domain/use_cases/user_model.dart';
import 'package:task/models/user.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserUseCase _useCase = UserUseCase();

  Future<String> createAccount(
      {required String emailAddress, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return 'Account created successfully';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message ?? 'Authentication error occurred.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signInWithEmailPassword(
      {required String emailAddress, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
      return 'Successful authentication.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return e.message ?? 'Authentication error';
    }
  }

  // add user to database
  Future<String> saveUserInfo(
      {required String email,
      required String password,
      required String name,
      required String gender,
      required String dob,
      required String mobile}) async {
    String res = 'Sign up failed, please try again';
    if (email.isNotEmpty ||
        password.isNotEmpty ||
        name.isNotEmpty ||
        gender.isNotEmpty ||
        dob.isNotEmpty ||
        mobile.isNotEmpty) {
      TaskUser user = TaskUser(
          name: name,
          uid: _auth.currentUser!.uid,
          email: email,
          gender: gender,
          dob: dob,
          mobile: mobile);
      _useCase.upload(_auth.currentUser!.uid, user);
      res = 'Account created successfully';
    }

    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
