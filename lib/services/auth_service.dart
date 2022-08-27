import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBn5MtYgXbSc1ukcur_aUc5ysBWMZhfNgg';

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken,
    });

    final response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (responseData.containsKey('idToken')) {
      //TODO: save token to local storage
      return null;
    } else {
      return responseData['error']['message'];
    }
  }
}
