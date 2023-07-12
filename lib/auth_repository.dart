import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String api = "http://52.90.252.193:8000";

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
      return "Erreur de connexion";
    }
  }
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());

