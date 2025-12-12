import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocket_notes_practice_2/core/services/data_service.dart';
import 'package:pocket_notes_practice_2/data/models/note.dart';

class AddEditScreen extends StatefulWidget {
  final Note? note;
  const AddEditScreen({super.key, this.note});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final DataService _dataService = DataService();

  String? selectedImagePath;
  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _bodyController.text = widget.note!.body;
      _dateController.text = widget.note!.date;

      selectedDate = widget.note!.date;
      selectedImagePath = widget.note!.imagePath;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = pickedImage.name;
      final savedImage = await File(
        pickedImage.path,
      ).copy("${appDir.path}/$fileName");
      setState(() {
        selectedImagePath = savedImage.path;
      });
    }
  }

  Future<void> saveNote() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      return;
    }
    final allNotes = await _dataService.getNotes();

    final Note newNote = Note(
      id: widget.note?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text,
      body: _bodyController.text,
      date: selectedDate.isEmpty ? _formatDate() : selectedDate,
      imagePath: selectedImagePath,
    );
    if (widget.note == null) {
      // add case
      allNotes.add(newNote);
    } else {
      // edit case
      final index = allNotes.indexWhere(
        (element) => element.id == widget.note!.id,
      );
      if (index != -1) {
        allNotes[index] = newNote;
      }
    }
    await _dataService.saveNotes(allNotes);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  String _formatDate() {
    final now = DateTime.now();
    final formattedDate =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.note == null ? "Add note" : "Edit note",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(hintText: "Note Title"),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _bodyController,
                  decoration: InputDecoration(hintText: "Note description"),
                  minLines: 6,
                  maxLines: null,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.date_range),
                    hintText: "Select date",
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() {
                              final formattedDate =
                                  "${newDate.day.toString().padLeft(2, '0')}/${newDate.month.toString().padLeft(2, '0')}/${newDate.year}";
                              setState(() {
                                selectedDate = formattedDate;
                                _dateController.text = formattedDate;
                              });
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 45),
                InkWell(
                  onTap: pickImage,
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Color(0xFF1E1E1E)
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(8),
                          border: isDarkMode
                              ? Border.all(color: Colors.grey)
                              : null,
                        ),
                        child: selectedImagePath == null
                            ? Icon(Icons.image, color: Colors.white)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(selectedImagePath!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          selectedImagePath == null
                              ? "Pick an Image"
                              : selectedImagePath!.split('/').last,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      saveNote();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(15),
                      ),
                    ),
                    child: Text(
                      widget.note == null ? "Save note" : "Save changes",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
