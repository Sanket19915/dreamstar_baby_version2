import 'package:dream_baby/core/storage/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});
  });

  test('saves and reads the token from secure storage', () async {
    await TokenStorage.save('secure-token');

    expect(await TokenStorage.read(), 'secure-token');
    expect((await SharedPreferences.getInstance()).getString('token'), isNull);
  });

  test('migrates an existing SharedPreferences token', () async {
    SharedPreferences.setMockInitialValues({'token': 'legacy-token'});

    expect(await TokenStorage.read(), 'legacy-token');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('token'), isNull);
    expect(
      await const FlutterSecureStorage().read(key: 'token'),
      'legacy-token',
    );
  });

  test('deletes secure and legacy token copies', () async {
    await TokenStorage.save('secure-token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', 'legacy-token');

    await TokenStorage.delete();

    expect(await TokenStorage.read(), isNull);
    expect(prefs.getString('userToken'), isNull);
  });
}
