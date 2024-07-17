import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user.dart';

class FirebaseAuthService {
  Future<User> _authenticate(
    String email,
    String password,
    String query,
  ) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$query?key=AIzaSyAc5BvJzSKz9XpJXl1I-8YCpzg0p9VGcYA");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);

        _saveUserData(user);
        return user;
      }

      final errorData = jsonDecode(response.body);
      throw (errorData['error']['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> register(String email, String password) async {
    // signUp

    return await _authenticate(email, password, "signUp");
  }

  Future<User> login(String email, String password) async {
    // signUp

    return await _authenticate(email, password, "signInWithPassword");
  }

  Future<User?> checkTokenExpiry() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userData = sharedPreferences.getString("userData");
    if (userData == null) {
      return null;
    }

    final user = jsonDecode(userData);

    if (DateTime.now().isBefore(
      DateTime.parse(
        user['expiresIn'],
      ),
    )) {
      return User(
        id: user['localId'],
        email: user['email'],
        token: user['idToken'],
        refreshToken: user['refreshToken'],
        expiresIn: DateTime.parse(
          user['expiresIn'],
        ),
      );
    }

    return null;
  }

  Future<void> _saveUserData(User user) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
      'userData',
      jsonEncode(
        user.toJson(),
      ),
    );
  }
}
