import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    EasyLoading.show();
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  static Future<User?> currentUser() async {
    return _auth.currentUser;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future signUp({
    required String email,
    required String displayName,
    required String password,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user;
    await user?.updateDisplayName(displayName);
    return user;
  }
}
