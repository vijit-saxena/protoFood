import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthProvider {
  Future<void> initialize();
  User? get currentUser;
  Future<User> logIn({PhoneAuthCredential phoneAuthCredential});
  Future<User> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
