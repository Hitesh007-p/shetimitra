class Product {
  final String name;
  final String description;
  final String image;
  final double price;
  final String unit;
  final double rating;

  const Product({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.unit,
    required this.rating,
  });

  String getFormattedPrice() {
    return '₹ ${price.toStringAsFixed(2)}'; // Format price with ₹ symbol and two decimal places
  }
}
