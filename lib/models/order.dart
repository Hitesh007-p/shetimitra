import 'package:shetimitra/models/product.dart';

class Order {
  final String id;
  final List<Product> products;
  final DateTime date;
  Order({
    required this.id,
    required this.products,
    required this.date,
  });
}
