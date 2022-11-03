class ImageSearch {
  List<ImagesResults>? imagesResults;

  ImageSearch({this.imagesResults});

  ImageSearch.fromJson(Map<String, dynamic> json) {
    if (json['images_results'] != null) {
      imagesResults = <ImagesResults>[];
      json['images_results'].forEach((v) {
        imagesResults!.add(ImagesResults.fromJson(v));
      });
    }
  }
}

class ImagesResults {
  int? position;
  String? thumbnail;
  String? source;
  String? title;
  String? link;
  String? original;
  int? originalWidth;
  int? originalHeight;
  bool? isProduct;
  bool? inStock;

  ImagesResults(
      {this.position,
      this.thumbnail,
      this.source,
      this.title,
      this.link,
      this.original,
      this.originalWidth,
      this.originalHeight,
      this.isProduct,
      this.inStock});

  ImagesResults.fromJson(Map<String, dynamic> json) {
    position = json['position'];
    thumbnail = json['thumbnail'];
    source = json['source'];
    title = json['title'];
    link = json['link'];
    original = json['original'];
    originalWidth = json['original_width'];
    originalHeight = json['original_height'];
    isProduct = json['is_product'];
    inStock = json['in_stock'];
  }
}
