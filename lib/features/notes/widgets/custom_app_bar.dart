import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_notes_practice_2/features/notes/screens/add_edit_screen.dart';

class CustomAppBar extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;
  final Future<void> Function() loadNotes;
  const CustomAppBar({
    super.key,
    required this.toggleTheme,
    required this.loadNotes,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              Text(
                "Pocket Notes",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: bgColor,
                child: IconButton(
                  onPressed: () {
                    widget.toggleTheme(
                      isDarkMode ? ThemeMode.light : ThemeMode.dark,
                    );
                  },
                  icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 23,
                backgroundColor: bgColor,
                child: IconButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      CupertinoPageRoute(builder: (context) => AddEditScreen()),
                    );
                    widget.loadNotes();
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
