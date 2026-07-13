import 'package:mockmate/features/auth/domain/auth_service.dart';

/// Local, session-only authentication used until the real provider is added.
///
/// Replacing this class with a production implementation does not require any
/// changes to the sign-in UI because consumers depend on [AuthService].
class TemporaryAuthService implements AuthService {
  bool _isSignedIn = false;

  @override
  Future<bool> isAuthenticated() => Future<bool>.value(_isSignedIn);

  @override
  Future<void> signIn() {
    _isSignedIn = true;
    return Future<void>.value();
  }

  @override
  Future<void> signOut() {
    _isSignedIn = false;
    return Future<void>.value();
  }
}
