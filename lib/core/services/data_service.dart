import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pocket_notes_practice_2/data/models/note.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  File? _file;

  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    _file = File("${appDir.path}/notes_data.json");
    if (!await _file!.exists()) {
      await _file!.create();
      await _file!.writeAsString(jsonEncode([]));
    }
  }

  Future<List<Note>> getNotes() async {
    try {
      if (_file == null) await init();
      final content = await _file!.readAsString();
      if (content.isEmpty) return [];

      final List<dynamic> jsonData = jsonDecode(content);
      final List<Note> notes = jsonData
          .map((element) => Note.fromMap(element))
          .toList();
      return notes.reversed.toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveNotes(List<Note> notes) async {
    if (_file == null) await init();
    final String jsonString = jsonEncode(
      notes.map((note) => note.toMap()).toList(),
    );
    await _file!.writeAsString(jsonString);
  }

  Future<void> deleteNote(Note note) async {
    if (_file == null) await init();
    final currentNotes = await getNotes();
    currentNotes.removeWhere((element) => element.id == note.id);
    await saveNotes(currentNotes);

    if (note.imagePath != null && note.imagePath!.isNotEmpty) {
      final imageFile = File(note.imagePath!);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    }
  }
}
