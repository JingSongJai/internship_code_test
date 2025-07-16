class ProductModel {
  final int id;
  final String productName;
  final double price;
  final int stock;

  ProductModel({
    required this.id,
    required this.productName,
    required this.price,
    required this.stock,
  });

  Map<String, dynamic> toJson() {
    return {'productName': productName, 'price': price, 'stock': stock};
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      productName: json['productName'] ?? '',
      price:
          json['price'] is num
              ? json['price'].toDouble()
              : double.parse(json['price']),
      stock:
          json['stock'] is num
              ? json['stock'].toInt()
              : int.parse(json['stock']),
    );
  }
}
