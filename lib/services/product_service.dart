import 'package:shetimitra/models/product.dart';

/// Mock Product Service - Simulates real backend product APIs
///
/// When backend API is ready, replace mock data with HTTP requests:
/// - Replace [getProducts] with: GET /api/products?category=seeds&limit=50
/// - Replace [getProductById] with: GET /api/products/{id}
/// - Replace [searchProducts] with: GET /api/products/search?q=tomato
/// - No structural changes needed
class ProductService {
  // static const String _baseUrl = 'https://your-backend.com/api'; // Replace when backend ready

  // Mock product database (replace with backend)
  static final List<Product> _allProducts = [
    // ===== SEEDS =====
    const Product(
      name: 'Hybrid Tomato Seeds',
      description:
          'High-yield hybrid tomato seeds with disease resistance. Suitable for all seasons. Produces medium-sized, round, red tomatoes. Maturity: 65-75 days.',
      image: 'assets/images/seeds1.jpg',
      price: 450.0,
      unit: 'packet',
      rating: 4.8,
    ),
    const Product(
      name: 'Premium Onion Bulbs',
      description:
          'Golden onion bulbs for year-round cultivation. Excellent storage life. Perfect for commercial farming. High shelf life of 4-5 months.',
      image: 'assets/images/seeds2.jpg',
      price: 580.0,
      unit: 'kg',
      rating: 4.6,
    ),
    const Product(
      name: 'Corn Seeds Premium',
      description:
          'High-quality corn seeds with excellent germination rate. Produces tall plants with good yield. Disease resistant variety. Maturity: 80-90 days.',
      image: 'assets/images/seeds3.jpg',
      price: 600.0,
      unit: 'kg',
      rating: 4.7,
    ),
    const Product(
      name: 'Chickpea Seeds',
      description:
          'Rabi season chickpea seeds with high protein content. Perfect for crop rotation. Disease resistant and drought tolerant. Maturity: 100-110 days.',
      image: 'assets/images/seeds4.jpg',
      price: 520.0,
      unit: 'kg',
      rating: 4.5,
    ),
    const Product(
      name: 'Cabbage Seeds',
      description:
          'Early winter cabbage seeds. Produces tight, dense heads. Excellent for storage and transportation. Maturity: 60-70 days.',
      image: 'assets/images/seeds5.jpg',
      unit: 'packet',
      price: 280.0,
      rating: 4.4,
    ),

    // ===== FERTILIZERS =====
    const Product(
      name: 'NPK Fertilizer 20:20:20',
      description:
          'Balanced NPK fertilizer for all crops. Promotes vegetative growth and fruit development. Dissolves quickly in water. 100% pure and effective.',
      image: 'assets/images/fertilizer1.jpg',
      price: 850.0,
      unit: 'bag(25kg)',
      rating: 4.9,
    ),
    const Product(
      name: 'Urea Fertilizer 46%',
      description:
          'High-nitrogen urea fertilizer for crop growth. Increases yield significantly. Easy to apply. Bulk discount available. Good water solubility.',
      image: 'assets/images/fertilizer2.jpg',
      price: 420.0,
      unit: 'bag(50kg)',
      rating: 4.7,
    ),
    const Product(
      name: 'Potassium Sulphate',
      description:
          'Rich source of potassium and sulphur. Improves fruit quality and disease resistance. Ideal for vegetable farming. Odor-free.',
      image: 'assets/images/fertilizer3.jpg',
      price: 1200.0,
      unit: 'bag(25kg)',
      rating: 4.6,
    ),
    const Product(
      name: 'DAP Fertilizer',
      description:
          'Diammonium phosphate for root development. Increases phosphorus and nitrogen. Excellent for wheat and pulses. Direct field application.',
      image: 'assets/images/fertilizer4.jpg',
      price: 780.0,
      unit: 'bag(50kg)',
      rating: 4.5,
    ),

    // ===== PESTICIDES & PEST CONTROL =====
    const Product(
      name: 'Pest Control Spray',
      description:
          'Broad-spectrum insecticide for controlling aphids, mites, and whiteflies. Organic ingredients, safe for vegetables. Ready to use formula.',
      image: 'assets/images/pesticide1.jpg',
      price: 320.0,
      unit: 'liter',
      rating: 4.7,
    ),
    const Product(
      name: 'Neem Oil Organic',
      description:
          'Pure neem oil for organic farming. Controls sucking insects and mites. Safe for humans and environment. Improves plant immunity.',
      image: 'assets/images/pesticide2.jpg',
      price: 450.0,
      unit: 'liter',
      rating: 4.8,
    ),
    const Product(
      name: 'Fungicide Solution',
      description:
          'Effective against powdery mildew and leaf spots. Curative and preventive action. Safe for vegetables and fruits. Easy dilution.',
      image: 'assets/images/pesticide3.jpg',
      price: 280.0,
      unit: 'liter',
      rating: 4.6,
    ),

    // ===== TOOLS & EQUIPMENT =====
    const Product(
      name: 'Drip Irrigation Kit',
      description:
          'Complete drip irrigation system for small farms (1 acre). Includes pipes, drippers, and connectors. Water-saving solution.',
      image: 'assets/images/tool1.jpg',
      price: 4500.0,
      unit: 'kit',
      rating: 4.5,
    ),
    const Product(
      name: 'Garden Tool Set',
      description:
          'Complete 5-piece garden tool set. Includes spade, shovel, fork, hoe, and rake. Durable metal construction. Perfect for farm work.',
      image: 'assets/images/tool2.jpg',
      price: 1200.0,
      unit: 'set',
      rating: 4.3,
    ),

    // ===== SOIL & AMENDMENTS =====
    const Product(
      name: 'Organic Compost',
      description:
          'Fully decomposed organic compost for soil enrichment. Improves soil fertility and water retention. Chemical-free. 100% natural.',
      image: 'assets/images/soil1.jpg',
      price: 350.0,
      unit: 'bag(25kg)',
      rating: 4.7,
    ),
    const Product(
      name: 'Peat Moss Premium',
      description:
          'High-quality peat moss for moisture retention and aeration. Ideal for nurseries and vegetable beds. Long-lasting effect.',
      image: 'assets/images/soil2.jpg',
      price: 280.0,
      unit: 'bag(10kg)',
      rating: 4.6,
    ),
  ];

  /// Get all products
  ///
  /// Real API: GET /api/products?limit=100
  Future<List<Product>> getProducts({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      await _simulateApiDelay();

      return _allProducts.skip(offset).take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  /// Get products by category
  ///
  /// Real API: GET /api/products?category=seeds&limit=50
  Future<List<Product>> getProductsByCategory({
    required String category,
    int limit = 50,
  }) async {
    try {
      await _simulateApiDelay();

      // Filter by category keyword
      final filtered = _allProducts.where((product) {
        final name = product.name.toLowerCase();
        final desc = product.description.toLowerCase();
        final categoryLower = category.toLowerCase();

        return name.contains(categoryLower) || desc.contains(categoryLower);
      }).toList();

      return filtered.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch products by category: $e');
    }
  }

  /// Search products by name or description
  ///
  /// Real API: GET /api/products/search?q=tomato&limit=20
  Future<List<Product>> searchProducts({
    required String query,
    int limit = 20,
  }) async {
    try {
      await _simulateApiDelay();

      final queryLower = query.toLowerCase();

      final results = _allProducts.where((product) {
        final name = product.name.toLowerCase();
        final desc = product.description.toLowerCase();

        return name.contains(queryLower) || desc.contains(queryLower);
      }).toList();

      return results.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  /// Get product by name (since we don't have IDs in Product model)
  ///
  /// Real API: GET /api/products/{id}
  Future<Product?> getProductByName(String productName) async {
    try {
      await _simulateApiDelay();

      return _allProducts.firstWhere(
        (product) => product.name.toLowerCase() == productName.toLowerCase(),
        orElse: () => _allProducts.first,
      );
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  /// Get featured/top-rated products
  ///
  /// Real API: GET /api/products/featured?limit=10
  Future<List<Product>> getFeaturedProducts({int limit = 10}) async {
    try {
      await _simulateApiDelay();

      final sorted = List<Product>.from(_allProducts);
      sorted.sort((a, b) => b.rating.compareTo(a.rating));

      return sorted.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch featured products: $e');
    }
  }

  /// Get products by price range
  ///
  /// Real API: GET /api/products?minPrice=100&maxPrice=500
  Future<List<Product>> getProductsByPriceRange({
    required double minPrice,
    required double maxPrice,
  }) async {
    try {
      await _simulateApiDelay();

      return _allProducts
          .where((p) => p.price >= minPrice && p.price <= maxPrice)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products by price range: $e');
    }
  }

  /// Get all categories (distinct product types)
  ///
  /// Real API: GET /api/products/categories
  Future<List<String>> getCategories() async {
    try {
      await _simulateApiDelay();

      const categories = [
        'Seeds',
        'Fertilizers',
        'Pesticides',
        'Tools',
        'Soil',
        'Nursery'
      ];

      return categories;
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  /// Add product to wishlist
  ///
  /// Real API: POST /api/users/wishlist
  Future<bool> addToWishlist(String productName) async {
    try {
      await _simulateApiDelay();
      // In real app, save to database
      return true;
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  /// Remove product from wishlist
  ///
  /// Real API: DELETE /api/users/wishlist/{productId}
  Future<bool> removeFromWishlist(String productName) async {
    try {
      await _simulateApiDelay();
      // In real app, remove from database
      return true;
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }

  // ============= HELPER METHODS =============

  /// Simulate network delay (remove when using real API)
  Future<void> _simulateApiDelay({int milliseconds = 600}) async {
    return Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// MIGRATION GUIDE: When Backend is Ready
  /// =====================================
  /// 1. Replace [getProducts]:
  ///    ```dart
  ///    final response = await http.get(
  ///      Uri.parse('$_baseUrl/products?limit=$limit&offset=$offset'),
  ///    );
  ///    final List<dynamic> data = jsonDecode(response.body);
  ///    return data.map((p) => Product(...)).toList();
  ///    ```
  ///
  /// 2. Replace [getProductsByCategory], [searchProducts], etc. similarly
  ///
  /// 3. Update [addToWishlist] and [removeFromWishlist] with actual API calls
  ///
  /// 4. No changes needed in:
  ///    - Product model
  ///    - UI components using this service
  ///    - Provider or Cart logic
}
