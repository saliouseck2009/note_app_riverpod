import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app_riv/models/note.dart';
import 'package:note_app_riv/network/api.dart';
import 'package:note_app_riv/utils/exception/token_not_found_exception.dart';
import 'package:note_app_riv/utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteRepository {
  final _prefs = SharedPreferences.getInstance();
  final Dio _dio = Dio();
  final String baseUrl = "$api/api/v1/notes";

  Future<List<Note>> getNotes() async {
    final prefs = await _prefs;
    final String? token = prefs.getString(PrefsKey.token);

    try {
      if (token == null) {
        throw TokenNotFoundException("Token not found");
      }
      final response = await _dio.get(
        baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      final notesList = response.data['notes'] as List;

      final notes = notesList.map((e) => Note.fromMap(e)).toList();
      return notes.reversed.toList();
    } on TokenNotFoundException catch (_) {
      rethrow;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Note> createNote({required Note note}) async {
    final prefs = await _prefs;
    final String? token = prefs.getString(PrefsKey.token);

    try {
      if (token == null) {
        throw TokenNotFoundException("Token not found");
      }
      print(note.toJson());
      final response = await _dio.post(baseUrl,
          data: {
            'title': note.title,
            'content': note.content,
          },
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      final noteCreated = Note.fromMap(response.data['note']);
      return noteCreated;
    } on TokenNotFoundException catch (_) {
      rethrow;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Note> updateNote({required Note note}) async {
    final prefs = await _prefs;
    final String? token = prefs.getString(PrefsKey.token);
    try {
      if (token == null) {
        throw TokenNotFoundException("Token not found");
      }
      final response = await _dio.put("$baseUrl/${note.id}",
          data: note.toJson(),
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return Note.fromMap(response.data['note']);
    } on TokenNotFoundException catch (_) {
      rethrow;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //delete note
  Future<String> deleteNote({required int noteId}) async {
    final prefs = await _prefs;
    final String? token = prefs.getString(PrefsKey.token);
    try {
      if (token == null) {
        throw TokenNotFoundException("Token not found");
      }
      final response = await _dio.delete("$baseUrl/$noteId",
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return response.data['message'];
    } on TokenNotFoundException catch (_) {
      rethrow;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

final noteRepositoryProvider =
    Provider<NoteRepository>((ref) => NoteRepository());
