import 'package:flutter_test/flutter_test.dart';
import 'package:mockmate/features/auth/data/temporary_auth_service.dart';

void main() {
  test('temporary auth service tracks session authentication', () async {
    final service = TemporaryAuthService();

    expect(await service.isAuthenticated(), isFalse);

    await service.signIn();
    expect(await service.isAuthenticated(), isTrue);

    await service.signOut();
    expect(await service.isAuthenticated(), isFalse);
  });
}
