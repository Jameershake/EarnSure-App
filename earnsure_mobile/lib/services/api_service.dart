import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://earnsure-backend.onrender.com/api';
  // For real device: static const String baseUrl = 'http://YOUR_IP:5000/api';

  static const Duration _timeout = Duration(seconds: 60);

  static Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print('❌ Token fetch error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await _getToken();
      final url = '$baseUrl$endpoint';

      print('🔵 POST: $url');
      print('📦 Body: $body');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: json.encode(body),
          )
          .timeout(_timeout, onTimeout: () {
        throw Exception('Request timeout');
      });

      print('📊 Status: ${response.statusCode}');
      print('📨 Response: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Request failed');
      }
    } catch (e) {
      print('❌ POST Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final token = await _getToken();
      final url = '$baseUrl$endpoint';

      print('🔵 GET: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(_timeout, onTimeout: () {
        throw Exception('Request timeout');
      });

      print('📊 Status: ${response.statusCode}');
      print('📨 Response: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Request failed');
      }
    } catch (e) {
      print('❌ GET Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await _getToken();
      final url = '$baseUrl$endpoint';

      print('🔵 PUT: $url');
      print('📦 Body: $body');

      final response = await http
          .put(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: json.encode(body),
          )
          .timeout(_timeout, onTimeout: () {
        throw Exception('Request timeout');
      });

      print('📊 Status: ${response.statusCode}');
      print('📨 Response: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Request failed');
      }
    } catch (e) {
      print('❌ PUT Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final token = await _getToken();
      final url = '$baseUrl$endpoint';

      print('🔵 DELETE: $url');

      final response = await http
          .delete(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(_timeout, onTimeout: () {
        throw Exception('Request timeout');
      });

      print('📊 Status: ${response.statusCode}');
      print('📨 Response: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Request failed');
      }
    } catch (e) {
      print('❌ DELETE Error: $e');
      rethrow;
    }
  }
}
