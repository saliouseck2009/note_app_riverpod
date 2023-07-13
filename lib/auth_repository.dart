import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String api = "http://34.201.57.108:8000";

class AuthRepository {
  
  final Dio _dio = Dio();

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '$api/api/v1/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

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
    try {
      final response = await Dio().post(
        '$api/api/v1/auth/signup',
        data: {
          'username': username,
          'password': password,
          'email': email,
        },
      );
      return response.data['accessToken'];
    } catch (e) {
      print(e);
      return "Erreur $e";
    }
  }
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());
