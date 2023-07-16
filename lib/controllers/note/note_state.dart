import 'package:equatable/equatable.dart';
import 'package:note_app_riv/models/note.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;

  const NoteLoaded({required this.notes});

  @override
  List<Object> get props => [notes];

  @override
  String toString() => 'NoteLoaded { notes: $notes }';
}

class NoteCreated extends NoteState {
  final Note note;

  const NoteCreated({required this.note});

  @override
  List<Object> get props => [note];

  @override
  String toString() => 'NoteLoaded { notes: $note }';
}

class NoteDeleted extends NoteState {
  final String message;
  const NoteDeleted({required this.message});
  @override
  List<Object> get props => [message];
}

class NoteError extends NoteState {
  final String message;

  const NoteError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'NoteError { message: $message }';
}
