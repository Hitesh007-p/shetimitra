import 'package:shetimitra/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Total price for this cart item (price × quantity)
  double get totalPrice => product.price * quantity;

  /// Create a copy with modified quantity
  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'product': {
        'name': product.name,
        'description': product.description,
        'image': product.image,
        'price': product.price,
        'unit': product.unit,
        'rating': product.rating,
      },
      'quantity': quantity,
    };
  }

  /// Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product(
        name: json['product']['name'],
        description: json['product']['description'],
        image: json['product']['image'],
        price: (json['product']['price'] as num).toDouble(),
        unit: json['product']['unit'],
        rating: (json['product']['rating'] as num).toDouble(),
      ),
      quantity: json['quantity'] ?? 1,
    );
  }
}
