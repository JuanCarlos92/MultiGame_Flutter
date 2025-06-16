class MockApi {
  // Test credentials
  static const _testUser = 'user@example.com';
  static const _testPassword = '1234';

  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check credentials
    return email == _testUser && password == _testPassword;
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty && password.length >= 4;
  }

  Future<bool> quickJoin(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.contains('@');
  }
}
