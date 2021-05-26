final String tablePictureCategories = 'categories';

class PictureCategoriesField {
  static final String id = '_id';
  static final String description = 'description';
}

class PictureCategory {
  final int? id;
  final String description;

  const PictureCategory({
    this.id,
    required this.description,
  });
}

enum Categories {
  undefined,
  trashbin,
  animal,
  tree,
  plant
}