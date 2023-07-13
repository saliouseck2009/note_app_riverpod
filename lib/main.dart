import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app_riv/screens/auth.dart';

void main() {
  runApp(const ProviderScope(child: AuthWidget()));
}
