import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket_notes_practice_2/data/models/note.dart';

class NoteCard extends StatefulWidget {
  final Note? note;
  final Future<void> Function(Note) onDelete;

  const NoteCard({super.key, required this.note, required this.onDelete});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Dismissible(
      key: Key(widget.note!.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        widget.onDelete(widget.note!);
      },
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(29),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(29),
          border: isDarkMode
              ? Border.all(color: Colors.white.withOpacity(0.5))
              : null,
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                offset: Offset(0, 10),
                blurRadius: 15,
              ),
          ],
        ),
        child: Row(
          children: [
            // Image preview
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF1E1E1E) : Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
                border: isDarkMode ? Border.all(color: Colors.grey) : null,
              ),
              child: widget.note!.imagePath == null
                  ? Icon(Icons.image, color: Colors.white)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(widget.note!.imagePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(width: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.note!.title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.note!.body,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.note!.date,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
