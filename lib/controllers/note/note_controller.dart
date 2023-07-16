import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app_riv/controllers/note/note_state.dart';
import 'package:note_app_riv/models/note.dart';
import 'package:note_app_riv/repositories/note_repository.dart';

final noteControllerProvider =
    StateNotifierProvider<NoteController, NoteState>((ref) {
  final noteRepository = ref.read(noteRepositoryProvider);
  return NoteController(
    noteRepository: noteRepository,
  );
});

class NoteController extends StateNotifier<NoteState> {
  final NoteRepository noteRepository;
  NoteController({
    required this.noteRepository,
  }) : super(NoteInitial());

  void getNotes() async {
    state = NoteLoading();
    try {
      await loadUpdatedList();
    } catch (e) {
      state = NoteError(message: e.toString());
    }
  }

  void addNotes({required Note note}) async {
    List<Note> notes = [];
    if (state is NoteLoaded) {
      notes = (state as NoteLoaded).notes;
    }
    //state = NoteLoading();
    try {
      final createdNote = await noteRepository.createNote(note: note);
      await loadUpdatedList();
    } catch (e) {
      state = NoteError(message: e.toString());
    }
  }

  Future<void> loadUpdatedList() async {
    final List<Note> updatedNotes = await noteRepository.getNotes();
    state = NoteLoaded(notes: updatedNotes);
  }

  void updateNotes({required Note note}) async {
    try {
      final result = await noteRepository.updateNote(note: note);
      state = NoteCreated(note: result);
      await loadUpdatedList();
    } catch (e) {
      state = NoteError(message: e.toString());
    }
  }

  void deleteNotes(int id) async {
    state = NoteLoading();
    try {
      final result = await noteRepository.deleteNote(noteId: id);
      state = NoteDeleted(message: result);
      await loadUpdatedList();
    } catch (e) {
      state = NoteError(message: e.toString());
    }
  }
}
