import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android emulator: 10.0.2.2 | iOS simulator: localhost | Real device: your PC's LAN IP
  static const String baseUrl = 'http://localhost:8080';

  // Keeps the JWT token in memory for the current app session
  static String? _token;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  static bool get isLoggedIn => _token != null;

  static void logout() {
    _token = null;
  }

  // ---- AUTH ----

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: _headers,
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
        'phoneNumber': phone,
      }),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && data['token'] != null) {
      _token = data['token'];
    } else {
      throw Exception(data['message'] ?? 'Registration failed');
    }
    return data;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode == 200 && data['token'] != null) {
      _token = data['token'];
    } else {
      throw Exception(data['message'] ?? 'Invalid email or password');
    }
    return data;
  }

  // ---- ACCOUNTS ----

  static Future<List<dynamic>> getMyAccounts() async {
    final res = await http.get(Uri.parse('$baseUrl/api/accounts'), headers: _headers);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to load accounts');
  }

  static Future<Map<String, dynamic>> createAccount(String accountType) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/accounts?accountType=$accountType'),
      headers: _headers,
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to create account');
  }

  // ---- TRANSACTIONS ----

  static Future<Map<String, dynamic>> processTransaction({
    required String type, // 'DEPOSIT', 'WITHDRAW', or 'TRANSFER'
    required double amount,
    String? fromAccount,
    String? toAccount,
    String? description,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/transactions'),
      headers: _headers,
      body: jsonEncode({
        'type': type,
        'amount': amount,
        if (fromAccount != null) 'fromAccountNumber': fromAccount,
        if (toAccount != null) 'toAccountNumber': toAccount,
        'description': description ?? '',
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    final data = jsonDecode(res.body);
    throw Exception(data['message'] ?? 'Transaction failed');
  }

  static Future<List<dynamic>> getTransactionHistory(int accountId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/transactions/history/$accountId'),
      headers: _headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to load transaction history');
  }
}