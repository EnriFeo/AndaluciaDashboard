class Product {
  final String? img;
  final String name;
  final String url;
  final double price;

  Product({
    required this.img,
    required this.name,
    required this.url,
    required this.price,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Product &&
            /*other.img == img &&
        other.name == name &&*/
            other.url == url /*&&
        other.price == price*/
        ;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
