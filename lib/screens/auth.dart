import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app_riv/widgets/login_form.dart';
import 'package:note_app_riv/widgets/sigup_form.dart';

final isLoginPage = StateNotifierProvider<AuthPageToggle, bool>((ref) {
  return AuthPageToggle();
});

class AuthPageToggle extends StateNotifier<bool> {
  AuthPageToggle() : super(true);

  void toggle() {
    state = !state;
  }
}

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(isLoginPage);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 75),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                InkWell(
                  onTap: () {
                    ref.read(isLoginPage.notifier).toggle();
                  },
                  child: Text("Login",
                      style: isLogin
                          ? Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)
                          : Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                ),
                InkWell(
                  onTap: () {
                    ref.read(isLoginPage.notifier).toggle();
                  },
                  child: Text("Sign Up",
                      style: isLogin
                          ? Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)
                          : Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                ),
              ]),
              const SizedBox(
                height: 50,
              ),
              Icon(
                color: Colors.grey,
                isLogin ? Icons.login : Icons.app_registration,
                size: 75,
              ),
              isLogin ? const LoginForm() : const SignupForm()
            ],
          ),
        )));
  }
}
