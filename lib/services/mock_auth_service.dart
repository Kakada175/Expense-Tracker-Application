class MockUser {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  MockUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

class MockAuthService {
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;
  MockAuthService._internal();

  final List<MockUser> _users = [];
  MockUser? _currentUser;

  // Sign up new user
  bool signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    // Check if user already exists
    if (_users.any((user) => user.email == email)) {
      return false; // User already exists
    }

    // Create new user
    final newUser = MockUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    _users.add(newUser);
    _currentUser = newUser;
    return true;
  }

  // Login user
  bool login({required String email, required String password}) {
    // Find user with matching email and password
    try {
      final user = _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
      _currentUser = user;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get current user
  MockUser? getCurrentUser() => _currentUser;

  // Logout
  void logout() {
    _currentUser = null;
  }

  // Check if user exists
  bool userExists(String email) {
    return _users.any((user) => user.email == email);
  }

  // Get all users (for debugging)
  List<MockUser> getAllUsers() => _users;
}
