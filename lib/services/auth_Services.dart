import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'alert_services.dart';

class AuthServices {
  final GetIt _getIt = GetIt.instance;
  late AlertServices _alertServices;

  AuthServices() {
    _firebaseAuth.authStateChanges().listen(authStateChangesStreamListner);

    _alertServices = _getIt.get<AlertServices>();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _user;

  User? get user {
    return _user;
  }

  Future<bool> login(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      print(credential);

      if (credential.user != null) {
        _user = credential.user;

        _alertServices.showToast(text: "Login Success");

        return true;
      }
    } on FirebaseException catch (e) {
      _alertServices.showToast(text: e.toString());
      print(e);
      return false;
    }
    return false;
  }

  Future<bool> logOut() async {
    try {
      await _firebaseAuth.signOut();
      _alertServices.showToast(text: "Logged Out");
      return true;
    } on FirebaseException catch (e) {
      _alertServices.showToast(text: e.toString());
      print(e);
    }
    return false;
  }

  Future<bool> deleteAccount() async {
    try {
      await _user!.delete();
      _alertServices.showToast(text: "User Deleted");

      // After deleting the user account, set _user to null
      _user = null;

      return true;
    } on FirebaseAuthException catch (e) {
      _alertServices.showToast(text: e.toString());
      print(e);
      return false;
    }
  }

  Future<bool> signUp({required String email, required String password}) async {
    try {
      final UserCredential _credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (_credential.user != null) {
        _user = _credential.user;
        _alertServices.showToast(text: "Account Created");

        return true;
      }
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        _alertServices.showToast(text: "Account already exists");
      } else {
        _alertServices.showToast(text: e.toString());
      }

      print(e);
    }
    return false;
  }

  //when first time the object of the class is created then this function runs and check that user is logged in or not or not, if it is
  // having the values then in constructor listner is provided which checks by passing the user from clound and set the lacal user value same.
  void authStateChangesStreamListner(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      _alertServices.showToast(text: "Password Recovery main has been sent");
    } on FirebaseException catch (e) {
      if (e.code == "invalid-email") {
        _alertServices.showToast(text: "Invalid email");
      } else {
        _alertServices.showToast(text: e.code.toString());
      }
      print(e);
    }
  }
}
