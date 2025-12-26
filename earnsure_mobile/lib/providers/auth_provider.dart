import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final SharedPreferences prefs;

  UserModel? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this.prefs) {
    checkAuth();
  }

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> checkAuth() async {
    try {
      print('🔵 CHECK AUTH: Checking stored auth...');
      
      final token = prefs.getString('auth_token');
      final userStr = prefs.getString('user_data');

      print('🔐 Token: ${token?.substring(0, 20)}...');
      print('👤 User data: $userStr');

      if (token != null && userStr != null) {
        _user = UserModel.fromJson(json.decode(userStr));
        _isAuthenticated = true;
        print('✅ Auth check: User logged in (${_user?.role})');
        notifyListeners();
      } else {
        print('❌ Auth check: No stored auth');
        _isAuthenticated = false;
      }
    } catch (e) {
      print('❌ Auth check error: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔵 LOGIN: Starting for $email');

      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      print('✅ LOGIN Response: success=${response['success']}');

      if (response['success'] == true) {
        final userData = response['user'];
        final token = response['token'];

        print('🔐 Token received: ${token.substring(0, 20)}...');
        print('👤 User: ${userData['name']} (${userData['role']})');

        // Save to storage
        await prefs.setString('auth_token', token);
        await prefs.setString('user_data', json.encode(userData));

        print('💾 Saved to SharedPreferences');

        // Verify saved
        final verifyToken = prefs.getString('auth_token');
        print('✓ Token verified: ${verifyToken?.substring(0, 20)}...');

        // Set locally
        _user = UserModel.fromJson(userData);
        _isAuthenticated = true;
        _isLoading = false;

        print('✅ LOGIN: Success! User: ${_user?.name}, Role: ${_user?.role}');
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Login failed';
        print('❌ LOGIN: Failed - $_error');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      print('❌ LOGIN Error: $_error');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔵 REGISTER: Starting for $email (role: $role)');

      final response = await ApiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': role,
      });

      print('✅ REGISTER Response: success=${response['success']}');

      if (response['success'] == true) {
        final userData = response['user'];
        final token = response['token'];

        print('🔐 Token received: ${token.substring(0, 20)}...');
        print('👤 User: ${userData['name']} (${userData['role']})');

        // Save to storage
        await prefs.setString('auth_token', token);
        await prefs.setString('user_data', json.encode(userData));

        print('💾 Saved to SharedPreferences');

        // Verify saved
        final verifyToken = prefs.getString('auth_token');
        print('✓ Token verified: ${verifyToken?.substring(0, 20)}...');

        // Set locally
        _user = UserModel.fromJson(userData);
        _isAuthenticated = true;
        _isLoading = false;

        print('✅ REGISTER: Success! User: ${_user?.name}, Role: ${_user?.role}');
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Registration failed';
        print('❌ REGISTER: Failed - $_error');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      print('❌ REGISTER Error: $_error');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    print('🔵 LOGOUT: Starting...');

    _user = null;
    _isAuthenticated = false;
    _error = null;

    await prefs.remove('auth_token');
    await prefs.remove('user_data');

    print('✅ LOGOUT: Success! All data cleared');
    notifyListeners();
  }
}
