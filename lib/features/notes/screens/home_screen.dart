import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_notes_practice_2/core/services/data_service.dart';
import 'package:pocket_notes_practice_2/data/models/note.dart';
import 'package:pocket_notes_practice_2/features/notes/screens/add_edit_screen.dart';
import 'package:pocket_notes_practice_2/features/notes/widgets/custom_app_bar.dart';
import 'package:pocket_notes_practice_2/features/notes/widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;
  final DataService _dataService = DataService();

  List<Note> allNotes = [];
  List<Note> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
    _searchController = TextEditingController();
  }

  Future<void> loadNotes() async {
    final notes = await _dataService.getNotes();
    setState(() {
      allNotes = notes;
      filteredNotes = notes;
    });
  }

  Future<void> deleteNote(Note note) async {
    await _dataService.deleteNote(note);
    loadNotes();
  }

  void handleSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredNotes = allNotes;
        return;
      });
    }

    setState(() {
      filteredNotes = allNotes
          .where(
            (element) =>
                element.title.contains(query) || element.body.contains(query),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 48),
          child: Column(
            children: [
              CustomAppBar(
                toggleTheme: widget.toggleTheme,
                loadNotes: loadNotes,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    if (!isDarkMode)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        offset: Offset(0, 15),
                        blurRadius: 15,
                      ),
                  ],
                ),
                child: TextFormField(
                  controller: _searchController,
                  onChanged: handleSearch,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: filteredNotes.isEmpty
                    ? Center(
                        child: Text(
                          "You don't have any notes. Try adding one!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredNotes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final note = filteredNotes[index];
                          return InkWell(
                            onTap: () async {
                              await Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      AddEditScreen(note: note),
                                ),
                              );
                              loadNotes();
                            },
                            child: NoteCard(note: note, onDelete: deleteNote),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
