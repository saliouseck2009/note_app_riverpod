import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app_riv/controllers/note/note_controller.dart';
import 'package:note_app_riv/controllers/note/note_state.dart';
import 'package:note_app_riv/models/note.dart';
import 'package:note_app_riv/screens/auth.dart';
import 'package:note_app_riv/widgets/add_note_form.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteState = ref.watch(noteControllerProvider);
    ref.listen<NoteState>(noteControllerProvider, (prev, next) {
      if (next is NoteCreated) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Note added')));
        ref.read(noteControllerProvider.notifier).getNotes();
      } else if (next is NoteDeleted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Note deleted')));
        ref.read(noteControllerProvider.notifier).getNotes();
      }
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Notes'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const AuthWidget()));
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: noteState is NoteLoaded
                ? Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const SearchBar(
                        hintText: 'Rechercher des notes',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: noteState.notes.length,
                        itemBuilder: (context, index) {
                          Note note = noteState.notes[index];
                          return InkWell(
                            onTap: () {},
                            child: Card(
                                shadowColor: Colors.transparent,
                                elevation: 0.5,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              note.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                            Text(
                                              note.content,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: PopupMenuExample(
                                            note: note,
                                          ))
                                    ],
                                  ),
                                )),
                          );
                        },
                      ))
                    ],
                  )
                : noteState is NoteLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : noteState is NoteError
                        ? Center(
                            child: Text(noteState.message,
                                style: const TextStyle(color: Colors.red)),
                          )
                        : const Center(
                            child: Text("No notes"),
                          )),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return const AddNoteForm(
                    title: "Add note",
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class PopupMenuExample extends ConsumerStatefulWidget {
  final Note note;
  const PopupMenuExample({super.key, required this.note});

  @override
  ConsumerState<PopupMenuExample> createState() => _PopupMenuExampleState();
}

class _PopupMenuExampleState extends ConsumerState<PopupMenuExample> {
  ActionItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ActionItem>(
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (ActionItem item) {
        if (item == ActionItem.delete) {
          ref
              .read(noteControllerProvider.notifier)
              .deleteNotes(widget.note.id!);
        } else {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return AddNoteForm(
                  title: "Edit note",
                  note: widget.note,
                );
              });
        }
        setState(() {
          selectedMenu = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ActionItem>>[
        const PopupMenuItem<ActionItem>(
          value: ActionItem.edit,
          child: Text('Edit'),
        ),
        const PopupMenuItem<ActionItem>(
          value: ActionItem.delete,
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

enum ActionItem { edit, delete }
