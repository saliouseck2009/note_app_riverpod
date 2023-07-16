import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app_riv/controllers/note/note_controller.dart';
import 'package:note_app_riv/models/note.dart';

class AddNoteForm extends ConsumerStatefulWidget {
  final Note? note;
  final String title;
  const AddNoteForm({super.key, this.note, required this.title});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends ConsumerState<AddNoteForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _contentController = TextEditingController(text: widget.note?.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(
            height: 16.0,
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Content',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter content';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          late final Note note;
                          if (widget.note != null) {
                            note = widget.note!.copyWith(
                                title: _titleController.text,
                                content: _contentController.text);
                          } else {
                            note = Note(
                                title: _titleController.text,
                                content: _contentController.text);
                          }
                          ref
                              .read(noteControllerProvider.notifier)
                              .addNotes(note: note);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save'))
                ],
              )),
        ],
      ),
    );
  }
}
