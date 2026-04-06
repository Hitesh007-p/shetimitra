import 'package:shetimitra/models/cart_item.dart';
import 'package:shetimitra/models/order_response.dart';
import 'dart:async';

/// Mock Order Service - Simulates real backend API calls
///
/// When backend API is ready, simply replace mock methods with real HTTP calls:
/// - Replace [_simulateApiDelay] with actual network requests
/// - Replace mock data with API responses
/// - No structural changes needed to app code
class OrderService {
  // static const String _baseUrl = 'https://your-backend.com/api'; // Replace when backend ready

  // Mock coupon database (replace with API call)
  static const Map<String, Map<String, dynamic>> _coupons = {
    'SAVE10': {'valid': true, 'discountPercent': 10, 'maxDiscount': 500},
    'SPRING20': {'valid': true, 'discountPercent': 20, 'maxDiscount': 1000},
    'HARVEST50': {'valid': true, 'discountPercent': 50, 'maxDiscount': 2000},
    'FARMER15': {'valid': true, 'discountPercent': 15, 'maxDiscount': 750},
    'WELCOME5': {'valid': true, 'discountPercent': 5, 'maxDiscount': 300},
  };

  // Mock orders database for demo (replace with backend)
  static final List<OrderResponse> _mockOrders = [
    OrderResponse(
      id: 'ORD-001',
      items: [
        {
          'productName': 'Hybrid Tomato Seeds',
          'quantity': 2,
          'price': 450.0,
          'unit': 'packet',
        }
      ],
      shippingAddress: '123 Farm Street, Nashik, Maharashtra 422001',
      deliveryDate: DateTime.now().add(const Duration(days: 3)),
      subtotal: 900.0,
      discount: 90.0,
      tax: 144.0,
      total: 954.0,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      paymentId: 'PAY-20260326-001',
    ),
    OrderResponse(
      id: 'ORD-002',
      items: [
        {
          'productName': 'NPK Fertilizer 20:20:20',
          'quantity': 1,
          'price': 850.0,
          'unit': 'bag',
        },
        {
          'productName': 'Pest Control Spray',
          'quantity': 2,
          'price': 320.0,
          'unit': 'liter',
        }
      ],
      shippingAddress: '456 Village Road, Pune, Maharashtra 411001',
      deliveryDate: DateTime.now().add(const Duration(days: 1)),
      subtotal: 1490.0,
      discount: null,
      tax: 238.4,
      total: 1728.4,
      status: OrderStatus.shipped,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      paymentId: 'PAY-20260330-002',
    ),
    OrderResponse(
      id: 'ORD-003',
      items: [
        {
          'productName': 'Corn Seeds Premium',
          'quantity': 3,
          'price': 600.0,
          'unit': 'kg',
        }
      ],
      shippingAddress: '789 Green Field, Indore, Madhya Pradesh 452001',
      deliveryDate: DateTime.now().add(const Duration(days: 5)),
      subtotal: 1800.0,
      discount: 180.0,
      tax: 259.2,
      total: 1879.2,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
      paymentId: 'PAY-20260402-003',
    ),
  ];

  /// Create a new order
  ///
  /// Real API: POST /api/orders
  /// Mock: Returns order with generated ID
  Future<OrderResponse> createOrder({
    required List<CartItem> items,
    required String shippingAddress,
    required DateTime deliveryDate,
    String? couponCode,
  }) async {
    try {
      await _simulateApiDelay();

      // Calculate totals
      double subtotal = items.fold(0, (sum, item) => sum + item.totalPrice);
      double discount = 0;

      // Apply coupon if valid
      if (couponCode != null && couponCode.isNotEmpty) {
        final coupon = await validateCoupon(couponCode);
        if (coupon['valid']) {
          final discountPercent = (coupon['discountPercent'] as num).toDouble();
          discount = (subtotal * discountPercent / 100)
              .clamp(0.0, (coupon['maxDiscount'] as num).toDouble());
        }
      }

      // Calculate tax (18% GST)
      double taxableAmount = subtotal - discount;
      double tax = (taxableAmount * 0.18).toDouble();
      double total = (taxableAmount + tax).toDouble();

      // Generate order ID
      final orderId = _generateOrderId();

      // Convert cart items to order items format
      final orderItems = items
          .map((item) => {
                'productName': item.product.name,
                'quantity': item.quantity,
                'price': item.product.price,
                'unit': item.product.unit,
                'image': item.product.image,
              })
          .toList();

      final order = OrderResponse(
        id: orderId,
        items: orderItems,
        shippingAddress: shippingAddress,
        deliveryDate: deliveryDate,
        couponCode: couponCode,
        subtotal: subtotal,
        discount: discount > 0 ? discount : null,
        tax: tax,
        total: total,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      // Save to mock database
      _mockOrders.add(order);

      return order;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  /// Get a specific order by ID
  ///
  /// Real API: GET /api/orders/{id}
  /// Mock: Returns order from mock database
  Future<OrderResponse> getOrder(String orderId) async {
    try {
      await _simulateApiDelay();

      final order = _mockOrders.firstWhere(
        (o) => o.id == orderId,
        orElse: () => throw Exception('Order not found: $orderId'),
      );

      return order;
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  /// Get all orders for current user
  ///
  /// Real API: GET /api/orders (with user auth)
  /// Mock: Returns all mock orders (in real app, would filter by userId)
  Future<List<OrderResponse>> getUserOrders() async {
    try {
      await _simulateApiDelay();

      // Sort by created date (newest first)
      _mockOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return _mockOrders;
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  /// Get orders filtered by status
  ///
  /// Real API: GET /api/orders?status=shipped
  /// Mock: Filters mock orders by status
  Future<List<OrderResponse>> getUserOrdersByStatus(OrderStatus status) async {
    try {
      await _simulateApiDelay();

      final filtered =
          _mockOrders.where((order) => order.status == status).toList();

      // Sort by created date (newest first)
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return filtered;
    } catch (e) {
      throw Exception('Failed to fetch orders by status: $e');
    }
  }

  /// Validate coupon code
  ///
  /// Real API: POST /api/coupons/validate
  /// Mock: Checks against mock coupon database
  Future<Map<String, dynamic>> validateCoupon(String code) async {
    try {
      await _simulateApiDelay();

      final coupon = _coupons[code.toUpperCase()];

      if (coupon == null) {
        return {
          'valid': false,
          'message': 'Invalid coupon code',
          'discountPercent': 0,
          'maxDiscount': 0,
        };
      }

      return {
        'valid': true,
        'discountPercent': coupon['discountPercent'],
        'maxDiscount': coupon['maxDiscount'],
        'message': 'Coupon applied successfully',
      };
    } catch (e) {
      return {
        'valid': false,
        'message': 'Error validating coupon: $e',
        'discountPercent': 0,
        'maxDiscount': 0,
      };
    }
  }

  /// Cancel an order
  ///
  /// Real API: POST /api/orders/{id}/cancel
  /// Mock: Updates order status to cancelled
  Future<bool> cancelOrder(String orderId) async {
    try {
      await _simulateApiDelay();

      final orderIndex = _mockOrders.indexWhere((o) => o.id == orderId);

      if (orderIndex == -1) {
        throw Exception('Order not found: $orderId');
      }

      final order = _mockOrders[orderIndex];

      // Can only cancel pending or confirmed orders
      if (order.status != OrderStatus.pending &&
          order.status != OrderStatus.confirmed) {
        throw Exception('Cannot cancel ${order.status.label} order');
      }

      // Create new order with cancelled status
      _mockOrders[orderIndex] = OrderResponse(
        id: order.id,
        items: order.items,
        shippingAddress: order.shippingAddress,
        deliveryDate: order.deliveryDate,
        couponCode: order.couponCode,
        subtotal: order.subtotal,
        discount: order.discount,
        tax: order.tax,
        total: order.total,
        status: OrderStatus.cancelled,
        createdAt: order.createdAt,
        paymentId: order.paymentId,
      );

      return true;
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  /// Update order status (admin/backend only)
  ///
  /// Real API: PUT /api/orders/{id}/status
  /// Mock: Updates status in mock database
  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _simulateApiDelay();

      final orderIndex = _mockOrders.indexWhere((o) => o.id == orderId);

      if (orderIndex == -1) {
        throw Exception('Order not found: $orderId');
      }

      final order = _mockOrders[orderIndex];

      _mockOrders[orderIndex] = OrderResponse(
        id: order.id,
        items: order.items,
        shippingAddress: order.shippingAddress,
        deliveryDate: order.deliveryDate,
        couponCode: order.couponCode,
        subtotal: order.subtotal,
        discount: order.discount,
        tax: order.tax,
        total: order.total,
        status: newStatus,
        createdAt: order.createdAt,
        paymentId: order.paymentId,
      );

      return true;
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  /// Verify payment after Razorpay
  ///
  /// Real API: POST /api/payments/verify
  /// Mock: Always returns success for demo
  Future<bool> verifyPayment({
    required String paymentId,
    required String signature,
    required String orderId,
  }) async {
    try {
      await _simulateApiDelay();

      // In real app, verify with Razorpay server
      // For demo, just validate format and update order
      if (paymentId.trim().isEmpty || signature.trim().isEmpty) {
        return false;
      }

      // Update order with payment ID and change status to confirmed
      final orderIndex = _mockOrders.indexWhere((o) => o.id == orderId);
      if (orderIndex >= 0) {
        final order = _mockOrders[orderIndex];
        _mockOrders[orderIndex] = OrderResponse(
          id: order.id,
          items: order.items,
          shippingAddress: order.shippingAddress,
          deliveryDate: order.deliveryDate,
          couponCode: order.couponCode,
          subtotal: order.subtotal,
          discount: order.discount,
          tax: order.tax,
          total: order.total,
          status: OrderStatus.confirmed,
          createdAt: order.createdAt,
          paymentId: paymentId,
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // ============= HELPER METHODS =============

  /// Simulate network delay (remove when using real API)
  Future<void> _simulateApiDelay({int milliseconds = 800}) async {
    return Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// Generate unique order ID
  String _generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'ORD-${timestamp.toString().substring(8, 12)}-$random';
  }

  /// MIGRATION GUIDE: When Backend is Ready
  /// =====================================
  /// 1. Replace [createOrder] method:
  ///    OLD: Uses _mockOrders and local calculation
  ///    NEW:
  ///    ```dart
  ///    final response = await http.post(
  ///      Uri.parse('$_baseUrl/orders'),
  ///      headers: {'Content-Type': 'application/json'},
  ///      body: jsonEncode({
  ///        'items': items.map(/*...*/),
  ///        'shippingAddress': shippingAddress,
  ///        'deliveryDate': deliveryDate.toIso8601String(),
  ///        'couponCode': couponCode,
  ///      }),
  ///    );
  ///    return OrderResponse.fromJson(jsonDecode(response.body));
  ///    ```
  ///
  /// 2. Replace [getOrder], [getUserOrders], [validateCoupon], [cancelOrder] similarly
  ///
  /// 3. Update [verifyPayment] to verify with Razorpay server:
  ///    ```dart
  ///    final response = await http.post(
  ///      Uri.parse('https://api.razorpay.com/v1/payments/$paymentId/verify'),
  ///      body: {'signature': signature, 'orderId': orderId},
  ///    );
  ///    ```
  ///
  /// 4. No changes needed in:
  ///    - UI components (CartProvider, Pages)
  ///    - Data models (CartItem, OrderResponse)
  ///    - Provider usage in widgets
}
