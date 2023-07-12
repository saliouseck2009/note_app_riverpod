import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app_riv/auth_repository.dart';

class AuthController extends StateNotifier<String> {
  final AuthRepository authRepository;
  AuthController({required this.authRepository}) : super("");

  void login(String username, String password) async {
    // final authRepository = ref.read(authRepositoryProvider);
    state = await authRepository.login(username, password);
    print(state);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, String>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});
