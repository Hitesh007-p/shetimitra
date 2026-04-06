enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get key {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }
}

class OrderResponse {
  final String id;
  final List<Map<String, dynamic>> items;
  final String shippingAddress;
  final DateTime deliveryDate;
  final String? couponCode;
  final double subtotal;
  final double? discount;
  final double tax;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String? paymentId;

  OrderResponse({
    required this.id,
    required this.items,
    required this.shippingAddress,
    required this.deliveryDate,
    this.couponCode,
    required this.subtotal,
    this.discount,
    required this.tax,
    required this.total,
    this.status = OrderStatus.pending,
    required this.createdAt,
    this.paymentId,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items,
      'shippingAddress': shippingAddress,
      'deliveryDate': deliveryDate.toIso8601String(),
      'couponCode': couponCode,
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'total': total,
      'status': status.key,
      'createdAt': createdAt.toIso8601String(),
      'paymentId': paymentId,
    };
  }

  /// Create from JSON
  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id'],
      items: List<Map<String, dynamic>>.from(json['items']),
      shippingAddress: json['shippingAddress'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      couponCode: json['couponCode'],
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: json['discount'] != null
          ? (json['discount'] as num).toDouble()
          : null,
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: _parseStatus(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      paymentId: json['paymentId'],
    );
  }

  static OrderStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
