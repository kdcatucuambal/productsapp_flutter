import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBn5MtYgXbSc1ukcur_aUc5ysBWMZhfNgg';
  final storage = const FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});
    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (responseData.containsKey('idToken')) {
      await storage.write(key: 'token', value: responseData['idToken']);
      return null;
    } else {
      return responseData['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});
    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData.containsKey('idToken')) {
      await storage.write(key: 'token', value: responseData['idToken']);
      return null;
    } else {
      throw Exception(responseData['error']['message']);
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
  }

  Future<String> readToken() async {
    final token = await storage.read(key: 'token');
    return token ?? '';
  }
}
