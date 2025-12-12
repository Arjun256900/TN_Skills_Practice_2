class Note {
  final String id;
  final String title;
  final String body;
  final String date;
  final String? imagePath;

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.imagePath,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      date: map['date'] ?? '',
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date,
      'imagePath': imagePath,
    };
  }
}
