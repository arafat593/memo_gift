import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  User? _user;

  bool _isSigningUp = false;

  bool get isLoading => _isLoading;
  User? get user => _user;

  AuthProvider() {
    _authService.user.listen((user) {
      if (_isSigningUp) return;
      _user = user;
      notifyListeners();
    });
  }

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    final cleanedEmail = email.trim();
    final cleanedPassword = password.trim();

    if (cleanedEmail.isEmpty || cleanedPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password are required')),
      );
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();
      await _authService.signIn(cleanedEmail, cleanedPassword);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login Failed: ${e.toString()}')));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(
    String email,
    String password,
    BuildContext context,
  ) async {
    final cleanedEmail = email.trim();
    final cleanedPassword = password.trim();

    if (cleanedEmail.isEmpty || cleanedPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password are required')),
      );
      return false;
    }

    try {
      _isSigningUp = true;
      _isLoading = true;
      notifyListeners();
      await _authService.signUp(cleanedEmail, cleanedPassword);
      // Immediately sign out to prevent auto-login
      await _authService.signOut();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please sign in.'),
          ),
        );
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Failed: ${e.toString()}')),
        );
      }
      return false;
    } finally {
      _isSigningUp = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null; // Explicitly null for faster UI response
    notifyListeners();
  }
}
