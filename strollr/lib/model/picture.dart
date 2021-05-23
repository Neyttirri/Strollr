import 'dart:typed_data';

final String tablePictures = 'pictures';

class PictureField {
  static final List<String> values = [
    id,
    data,
    createdAt,
    color,
    size,
    description,
    location,
    category,
    walk_id
  ];

  static final String id = '_id';
  static final String data = 'data';
  static final String createdAt = 'created_at';
  static final String color = 'color';
  static final String size = 'size';
  static final String description = 'description';
  static final String location = 'location';
  static final String category = 'categories';
  // ignore: non_constant_identifier_names
  static final String walk_id = 'walk_id';
}

class Picture {
  int? id;
  Uint8List pictureData;
  DateTime createdAtTime;
  String color;
  String size;
  String description;
  String location;
  int category;
  // ignore: non_constant_identifier_names
  int walk_id;

  Picture({
    this.id,
    required this.pictureData,
    required this.createdAtTime,
    required this.color,
    required this.size,
    required this.description,
    required this.location,
    required this.category,
    // ignore: non_constant_identifier_names
    required this.walk_id,
  });

  /// convert the current picture object to json format to insert it into the database
  Map<String, Object?> toJson() => {
        PictureField.id: id,
        PictureField.data: pictureData,
        PictureField.createdAt: createdAtTime.toIso8601String(),
        PictureField.color: color,
        PictureField.size: size,
        PictureField.description: description,
        PictureField.location: location,
        PictureField.category: category,
        PictureField.walk_id: walk_id,
      };

  /// convert json input from the database into a picture object
  static Picture fromJson(Map<String, Object?> json) => Picture(
        id: json[PictureField.id] as int?,
        pictureData: json[PictureField.data] as Uint8List,
        createdAtTime: DateTime.parse(json[PictureField.createdAt] as String),
        color: json[PictureField.color] as String,
        size: json[PictureField.size] as String,
        description: json[PictureField.description] as String,
        location: json[PictureField.location] as String,
        category: json[PictureField.category] as int,
        walk_id: json[PictureField.walk_id] as int,
      );

  /// creating a copy of the current picture object
  Picture copy({
    int? id,
    Uint8List? pictureData,
    DateTime? createdAtTime,
    String? color,
    String? size,
    String? description,
    String? location,
    int? category,
    // ignore: non_constant_identifier_names
    int? walk_id,
  }) =>
      Picture(
        id: id ?? this.id,
        pictureData: pictureData ?? this.pictureData,
        createdAtTime: createdAtTime ?? this.createdAtTime,
        color: color ?? this.color,
        size: size ?? this.size,
        description: description ?? this.description,
        location: location ?? this.location,
        category: category ?? this.category,
        walk_id: walk_id ?? this.walk_id,
      );
}
