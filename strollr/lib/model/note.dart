final String tableNotes = 'notes';

class NoteFields {
  static final String id = '_id';
  static final String data = 'data';
  static final String created_at = 'created_at';
  static final String color = 'color';
  static final String size = 'size';
  static final String description = 'description';
  static final String location = 'location';
  static final String categories = 'categories';
  static final String walk_id = 'walk_id';

}

class Note {
  final int? id;
  final String data;
  final String created_at;
  final String color;
  final int size;
  final String description;
  final String location;
  final String categories;
  final int walk_id;

  const Note({
    this.id,
    required this.data,
    required this.created_at,
    required this.color,
    required this.size,
    required this.description,
    required this.location,
    required this.categories,
    required this.walk_id,
  });
}