abstract interface class AuthService {
  Future<void> signIn({String? email, String? password});

  Future<void> signUp({required String email, required String password});

  Future<void> signOut();

  Future<bool> isAuthenticated();

  String? get currentUserEmail;
}

