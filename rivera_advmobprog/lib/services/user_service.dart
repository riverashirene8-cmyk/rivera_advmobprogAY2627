import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

class UserService {
  // ENHANCEMENT 2:
  // Authenticates the user using the DummyJSON login API
  // and saves the authenticated user's information locally.
  Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    final String url = '$host/auth/login';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 60,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(
        jsonDecode(response.body),
      );

      await saveUserData(data);

      return data;
    }

    throw Exception(
      'Invalid username or password.',
    );
  }

  // ENHANCEMENT 3:
  // Converts the authenticated user's API data into the User model
  // and stores the user's information in SharedPreferences.
  Future<void> saveUserData(
    Map<String, dynamic> userData,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final user = User.fromJson(userData);

    await prefs.setInt('id', user.id);
    await prefs.setString(
      'username',
      user.username,
    );
    await prefs.setString(
      'email',
      user.email,
    );
    await prefs.setString(
      'firstName',
      user.firstName,
    );
    await prefs.setString(
      'lastName',
      user.lastName,
    );
    await prefs.setString(
      'gender',
      user.gender,
    );
    await prefs.setString(
      'phone',
      user.phone,
    );
    await prefs.setString(
      'address',
      user.address,
    );
    await prefs.setString(
      'image',
      user.image,
    );
    await prefs.setString(
      'accessToken',
      user.accessToken,
    );
    await prefs.setString(
      'refreshToken',
      user.refreshToken,
    );
  }

  // Retrieves the saved user information from SharedPreferences.
  Future<Map<String, dynamic>> getUserData() async {
    final prefs =
        await SharedPreferences.getInstance();

    return {
      'id': prefs.getInt('id') ?? 0,
      'username':
          prefs.getString('username') ?? '',
      'email':
          prefs.getString('email') ?? '',
      'firstName':
          prefs.getString('firstName') ?? '',
      'lastName':
          prefs.getString('lastName') ?? '',
      'gender':
          prefs.getString('gender') ?? '',
      'phone':
          prefs.getString('phone') ?? '',
      'address': {
        'address':
            prefs.getString('address') ?? '',
      },
      'image':
          prefs.getString('image') ?? '',
      'accessToken':
          prefs.getString('accessToken') ?? '',
      'refreshToken':
          prefs.getString('refreshToken') ?? '',
    };
  }

  // ENHANCEMENT 3:
  // Returns the saved user as a User model so that the
  // profile screen and cart can use the current user's data.
  Future<User> getUser() async {
    final userData =
        await getUserData();

    return User.fromJson(userData);
  }

  // ENHANCEMENT 1:
  // Checks whether an access token is saved locally.
  // This allows the splash screen to determine whether
  // the user should stay logged in or go to the sign-in screen.
  Future<bool> isLoggedIn() async {
    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('accessToken') ?? '';

    return token.isNotEmpty;
  }

  // Clears the saved authentication data when the user logs out.
  Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();
  }
}