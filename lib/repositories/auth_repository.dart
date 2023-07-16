import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app_riv/utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api.dart';

class AuthRepository {
  final _prefs = SharedPreferences.getInstance();

  final Dio _dio = Dio();
  final String baseUrl = "$api/api/v1/auth/";

  Future<String> login(String username, String password) async {
    final prefs = await _prefs;
    try {
      final response = await _dio.post(
        '${baseUrl}login',
        data: {
          'username': username,
          'password': password,
        },
      );
      if (response.data['accessToken'] != null) {
        prefs.setString(PrefsKey.token, response.data['accessToken']);
      }

      return response.data['accessToken'];
    } catch (e) {
      print(e);
      return "Erreur $e";
    }
  }

  Future<String> signup({
    required String username,
    required String password,
    required String email,
  }) async {
    final prefs = await _prefs;
    try {
      final response = await Dio().post(
        '${baseUrl}signup',
        data: {
          'username': username,
          'password': password,
          'email': email,
        },
      );
      if (response.data['accessToken'] != null) {
        prefs.setString(
            PrefsKey.token, response.data['idToken']['accessToken']);
      }

      return response.data['accessToken'];
    } catch (e) {
      print(e);
      return "Erreur $e";
    }
  }
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());
