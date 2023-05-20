import 'package:firebase_auth/firebase_auth.dart';

import 'auth_provider.dart';
import 'firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<User> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  User? get currentUser => provider.currentUser;

  @override
  Future<User> logIn({PhoneAuthCredential? phoneAuthCredential}) =>
      provider.logIn(phoneAuthCredential: phoneAuthCredential!);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
