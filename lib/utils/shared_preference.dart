import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final prefsProvider = Provider((_) async {
  return await SharedPreferences.getInstance();
});

class PrefsKey {
  static const String token = 'token';
}
