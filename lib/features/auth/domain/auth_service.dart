abstract interface class AuthService {
  Future<void> signIn();

  Future<void> signOut();

  Future<bool> isAuthenticated();
}
