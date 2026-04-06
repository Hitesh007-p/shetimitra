import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shetimitra/models/cart_item.dart';
import 'package:shetimitra/models/product.dart';
import 'dart:convert';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  /// Get all cart items
  List<CartItem> get items => _items;

  /// Get total number of items (by count, not quantity)
  int get itemCount => _items.length;

  /// Get total quantity (sum of all quantities)
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Get total price of all items
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  /// Initialize provider and load saved cart
  Future<void> init() async {
    await _loadCartFromStorage();
  }

  /// Add product to cart or increase quantity if already exists
  void addToCart(Product product, int quantity) {
    final existingIndex =
        _items.indexWhere((item) => item.product.name == product.name);

    if (existingIndex >= 0) {
      // Product already in cart, increase quantity
      _items[existingIndex] = _items[existingIndex]
          .copyWith(quantity: _items[existingIndex].quantity + quantity);
    } else {
      // New product, add to cart
      _items.add(CartItem(product: product, quantity: quantity));
    }

    _saveCartToStorage();
    notifyListeners();
  }

  /// Remove product from cart
  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.name == product.name);
    _saveCartToStorage();
    notifyListeners();
  }

  /// Update quantity of a product in cart
  void updateQuantity(Product product, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(product);
      return;
    }

    final index =
        _items.indexWhere((item) => item.product.name == product.name);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
      _saveCartToStorage();
      notifyListeners();
    }
  }

  /// Clear entire cart
  void clearCart() {
    _items.clear();
    _saveCartToStorage();
    notifyListeners();
  }

  /// Check if product is in cart
  bool isInCart(Product product) {
    return _items.any((item) => item.product.name == product.name);
  }

  /// Get cart item for a product
  CartItem? getCartItem(Product product) {
    try {
      return _items.firstWhere((item) => item.product.name == product.name);
    } catch (e) {
      return null;
    }
  }

  /// Save cart to SharedPreferences
  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = jsonEncode(_items.map((item) => item.toJson()).toList());
      await prefs.setString('cart_items', cartJson);
    } catch (e) {
      if (kDebugMode) print('Error saving cart: $e');
    }
  }

  /// Load cart from SharedPreferences
  Future<void> _loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('cart_items');

      if (cartJson != null && cartJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(cartJson);
        _items = decoded.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) print('Error loading cart: $e');
    }
  }
}
