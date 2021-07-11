class CollectionListCard {
  final String categoryImage;
  final String categoryName;
  final int categoryId;
  int _itemCount = 0;


  CollectionListCard(this.categoryImage, this.categoryName, this.categoryId);

  set itemCount(count) => _itemCount = count;
  get itemCount {return _itemCount;}


}