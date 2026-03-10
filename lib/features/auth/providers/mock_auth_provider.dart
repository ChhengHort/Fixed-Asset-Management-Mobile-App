import 'package:flutter/material.dart';
import '../models/mock_user.dart';

class MockAuthProvider extends ChangeNotifier {
  MockUser? _currentUser;
  bool _isAuthenticated = false;

  MockUser? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String get approverName => _currentUser?.displayName ?? 'Unknown';

  /// Attempt login with username/email and password
  /// Returns true if successful, false otherwise
  Future<bool> login(String usernameOrEmail, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Simple validation: password must be at least 6 characters
    if (password.isEmpty || password.length < 6) {
      return false;
    }

    // Find user by username or email
    try {
      final user = mockUsers.firstWhere(
        (u) => u.username == usernameOrEmail || u.email == usernameOrEmail,
      );

      _currentUser = user;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      // User not found
      return false;
    }
  }

  /// Logout current user
  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
