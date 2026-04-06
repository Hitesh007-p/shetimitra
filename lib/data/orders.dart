import 'package:shetimitra/data/products.dart';
import 'package:shetimitra/models/order.dart';

List<Order> orders = [
  Order(
    id: "202304a5",
    products: products.reversed.take(3).toList(),
    date: DateTime.utc(2023),
    shippingAddress: '123 Farm Lane, Nashik, Maharashtra',
    deliveryDate: DateTime.utc(2023).add(const Duration(days: 3)),
    subtotal: 2500.0,
    tax: 450.0,
    total: 2950.0,
  ),
  Order(
    id: "202204jm",
    products: products.take(1).toList(),
    date: DateTime.utc(2022),
    shippingAddress: '456 Village Road, Pune, Maharashtra',
    deliveryDate: DateTime.utc(2022).add(const Duration(days: 3)),
    subtotal: 1200.0,
    tax: 216.0,
    total: 1416.0,
  ),
  Order(
    id: "201904vc",
    products: products.reversed.skip(2).toList(),
    date: DateTime.utc(2019),
    shippingAddress: '789 Green Field, Indore, Madhya Pradesh',
    deliveryDate: DateTime.utc(2019).add(const Duration(days: 3)),
    subtotal: 3000.0,
    tax: 540.0,
    total: 3540.0,
  ),
];
