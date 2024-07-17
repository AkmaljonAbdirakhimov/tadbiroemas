import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/product.dart';

class FirebaseProductService {
  final String _baseUrl = "https://dars66-ae91b-default-rtdb.firebaseio.com";

  Future<List<Product>> getProducts() async {
    final userToken = await _getUserToken();

    Uri url = Uri.parse("$_baseUrl/products.json?auth=$userToken");

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw (errorData['error']);
      }

      final data = jsonDecode(response.body);
      List<Product> products = [];

      if (data != null) {
        data.forEach((key, value) {
          products.add(Product(id: key, title: value['title']));
        });
      }

      return products;
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> addProduct(String title) async {
    final userToken = await _getUserToken();
    Uri url = Uri.parse("$_baseUrl/products.json?auth=$userToken");

    try {
      final response = await http.post(url,
          body: jsonEncode({
            "title": title,
          }));

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw (errorData['error']);
      }

      final data = jsonDecode(response.body);

      return Product(id: data['name'], title: title);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editProduct(String id, String title) async {
    final userToken = await _getUserToken();
    Uri url = Uri.parse("$_baseUrl/products/$id.json?auth=$userToken");

    try {
      final response = await http.patch(url,
          body: jsonEncode({
            "title": title,
          }));

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw (errorData['error']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final userToken = await _getUserToken();
    Uri url = Uri.parse("$_baseUrl/products/$id.json?auth=$userToken");

    try {
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw (errorData['error']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");

    if (userData == null) {
      // redirect to login
    }

    Map<String, dynamic> user = jsonDecode(userData!);
    bool isTokenExpired = DateTime.now().isAfter(
      DateTime.parse(
        user['expiresIn'],
      ),
    );

    if (!isTokenExpired) {
      // refresh token
      user = await _refreshToken(user);
      prefs.setString("userData", jsonEncode(user));
    }

    return user['idToken'];
  }

  Future<Map<String, dynamic>> _refreshToken(Map<String, dynamic> user) async {
    Uri url = Uri.parse(
        "https://securetoken.googleapis.com/v1/token?key=AIzaSyAc5BvJzSKz9XpJXl1I-8YCpzg0p9VGcYA");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            "grant_type": "refresh_token",
            "refresh_token": user['refreshToken'],
          },
        ),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw (errorData['error']);
      }

      final data = jsonDecode(response.body);

      user['refreshToken'] = data['refresh_token'];
      user['idToken'] = data['id_token'];
      user['expiresIn'] = DateTime.now()
          .add(
            Duration(
              seconds: int.parse(
                data['expires_in'],
              ),
            ),
          )
          .toString();
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
