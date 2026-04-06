import 'package:shetimitra/models/product.dart';
import 'package:shetimitra/models/order_response.dart';

class Order {
  final String id;
  final List<Product> products;
  final DateTime date;
  final String shippingAddress;
  final DateTime deliveryDate;
  final String? couponCode;
  final double subtotal;
  final double? discount;
  final double tax;
  final double total;
  final OrderStatus status;
  final String? paymentId;

  Order({
    required this.id,
    required this.products,
    required this.date,
    required this.shippingAddress,
    required this.deliveryDate,
    this.couponCode,
    required this.subtotal,
    this.discount,
    required this.tax,
    required this.total,
    this.status = OrderStatus.pending,
    this.paymentId,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products
          .map((p) => {
                'name': p.name,
                'description': p.description,
                'image': p.image,
                'price': p.price,
                'unit': p.unit,
                'rating': p.rating,
              })
          .toList(),
      'date': date.toIso8601String(),
      'shippingAddress': shippingAddress,
      'deliveryDate': deliveryDate.toIso8601String(),
      'couponCode': couponCode,
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'total': total,
      'status': status.key,
      'paymentId': paymentId,
    };
  }

  /// Create from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      products: (json['products'] as List)
          .map((p) => Product(
                name: p['name'],
                description: p['description'],
                image: p['image'],
                price: (p['price'] as num).toDouble(),
                unit: p['unit'],
                rating: (p['rating'] as num).toDouble(),
              ))
          .toList(),
      date: DateTime.parse(json['date']),
      shippingAddress: json['shippingAddress'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      couponCode: json['couponCode'],
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: json['discount'] != null
          ? (json['discount'] as num).toDouble()
          : null,
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (status) => status.key == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentId: json['paymentId'],
    );
  }
}
