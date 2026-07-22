import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockmate/features/auth/domain/auth_service.dart';

/// Firebase Authentication implementation of [AuthService].
class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<void> signIn({String? email, String? password}) async {
    if (email != null &&
        password != null &&
        email.trim().isNotEmpty &&
        password.isNotEmpty) {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } else {
      await _firebaseAuth.signInAnonymously();
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  String? get currentUserEmail => _firebaseAuth.currentUser?.email;
}
