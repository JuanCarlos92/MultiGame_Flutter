
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_game_app/api/mock_api.dart';

void main() {
  final api = MockApi();

  test('Successful login with correct credentials', () async {
    final result = await api.login('user@example.com', '1234');
    expect(result, isTrue);
  });

  test('Failed login with incorrect credentials', () async {
    final result = await api.login('wrong@example.com', 'wrong');
    expect(result, isFalse);
  });

  test('Successful registration with valid data', () async {
    final result = await api.register('test@example.com', 'pass1234');
    expect(result, isTrue);
  });

  test('Failed registration with invalid data', () async {
    final result = await api.register('', '123');
    expect(result, isFalse);
  });

  test('Quick join succeeds with valid email', () async {
    final result = await api.quickJoin('quick@example.com');
    expect(result, isTrue);
  });

  test('Quick join fails with invalid email', () async {
    final result = await api.quickJoin('invalid_email');
    expect(result, isFalse);
  });
}
