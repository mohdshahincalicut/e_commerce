import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/sample_data.dart';

class DatabaseProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  Map<String, dynamic> _cart = {};
  List<Map<String, dynamic>> _orders = [];
  List<String> _wishlist = [];
  List<Map<String, dynamic>> _categories = [];

  // Loading states
  bool _isLoadingProducts = false;
  bool _isLoadingCart = false;
  bool _isLoadingOrders = false;
  bool _isLoadingWishlist = false;
  bool _isLoadingCategories = false;

  // Error states
  String? _productsError;
  String? _cartError;
  String? _ordersError;
  String? _wishlistError;
  String? _categoriesError;

  // Getters
  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get filteredProducts => _filteredProducts;
  Map<String, dynamic> get cart => _cart;
  List<Map<String, dynamic>> get orders => _orders;
  List<String> get wishlist => _wishlist;
  List<Map<String, dynamic>> get categories => _categories;

  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingCart => _isLoadingCart;
  bool get isLoadingOrders => _isLoadingOrders;
  bool get isLoadingWishlist => _isLoadingWishlist;
  bool get isLoadingCategories => _isLoadingCategories;

  String? get productsError => _productsError;
  String? get cartError => _cartError;
  String? get ordersError => _ordersError;
  String? get wishlistError => _wishlistError;
  String? get categoriesError => _categoriesError;

  double get cartTotal {
    double total = 0.0;
    _cart.forEach((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('price') && value.containsKey('quantity')) {
        total += (value['price'] as double) * (value['quantity'] as int);
      }
    });
    return total;
  }

  int get cartItemCount {
    return _cart.length;
  }

  DatabaseProvider() {
    _initializeData();
  }

  // Initialize data from sample data
  Future<void> _initializeData() async {
    await loadProducts();
    await loadCategories();
  }

  // ==================== PRODUCTS ====================

  Future<void> loadProducts() async {
    _isLoadingProducts = true;
    _productsError = null;
    notifyListeners();

    try {
      // Try to load from Firestore if available
      try {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final QuerySnapshot querySnapshot = await firestore.collection('products').get();
        
        _products = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          // Add document ID as product ID
          data['id'] = doc.id;
          
          // Convert price to double if it's a number
          if (data['price'] is num) {
            data['price'] = (data['price'] as num).toDouble();
          }
          
          // Convert originalPrice to double if it's a string (remove currency symbols)
          if (data['originalPrice'] is String) {
            final originalPriceStr = data['originalPrice'] as String;
            final numericValue = originalPriceStr.replaceAll(RegExp(r'[^\d.]'), '');
            data['originalPrice'] = double.tryParse(numericValue) ?? 0.0;
          } else if (data['originalPrice'] is num) {
            data['originalPrice'] = (data['originalPrice'] as num).toDouble();
          }
          
          // Convert rating to double
          if (data['rating'] is num) {
            data['rating'] = (data['rating'] as num).toDouble();
          }
          
          // Convert reviews to int
          if (data['reviews'] is num) {
            data['reviews'] = (data['reviews'] as num).toInt();
          }
          
          // Convert stock to int
          if (data['stock'] is num) {
            data['stock'] = (data['stock'] as num).toInt();
          }
          
          return data;
        }).toList();
        
        print('Successfully loaded ${_products.length} products from Firestore');
      } catch (firestoreError) {
        print('Firestore not available, using sample data: $firestoreError');
        // Fall back to sample data with Firestore structure
        _products = _getSampleProductsWithFirestoreStructure();
      }
      
      _filteredProducts = List.from(_products);
      _isLoadingProducts = false;
      notifyListeners();
    } catch (e) {
      _productsError = e.toString();
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _getSampleProductsWithFirestoreStructure() {
    return [
      {
        'id': 'product_1',
        'categoryId': 'electronics',
        'color': 'pink',
        'createdAt': DateTime.now(),
        'description': 'Powerful tablet with M1 chip, all-day battery, and Apple Pencil support',
        'discount': '14%',
        'icon': 'keyboard',
        'images': [
          'https://i5.walmartimages.com/seo/Apple-10-5-inch-iPad-Air-Wi-Fi-64GB-Gold_e2056aea-1604-4640-96dd-f982e10322e2_1.02df42f3e9fd3cf109b311bda0b9c63e.jpeg',
          'https://i5.walmartimages.com/seo/Apple-10-5-inch-iPad-Air-Wi-Fi-64GB-Gold_e2056aea-1604-4640-96dd-f982e10322e2_1.02df42f3e9fd3cf109b311bda0b9c63e.jpeg'
        ],
        'name': 'iPad Air 5th Gen',
        'originalPrice': 'AED 2,899',
        'price': 2499.0,
        'rating': 4.5,
        'reviews': 234,
        'specifications': {
          'brand': 'Apple',
          'connectivity': 'Wi-Fi + Cellular',
          'display': '10.9" Liquid Retina',
          'features': 'Apple Pencil 2 support, Magic Keyboard',
          'processor': 'M1 chip',
          'storage': '256GB'
        },
        'stock': 28,
        'updatedAt': DateTime.now(),
      },
      {
        'id': 'product_2',
        'categoryId': 'electronics',
        'color': 'blue',
        'createdAt': DateTime.now(),
        'description': 'High-performance wireless headphones with noise cancellation',
        'discount': '20%',
        'icon': 'headphones',
        'images': [
          'https://example.com/headphones1.jpg',
          'https://example.com/headphones2.jpg'
        ],
        'name': 'Sony WH-1000XM4',
        'originalPrice': 'AED 1,299',
        'price': 1039.0,
        'rating': 4.8,
        'reviews': 156,
        'specifications': {
          'brand': 'Sony',
          'connectivity': 'Bluetooth 5.0',
          'features': 'Noise Cancellation, 30-hour battery',
          'weight': '254g'
        },
        'stock': 15,
        'updatedAt': DateTime.now(),
      },
      {
        'id': 'product_3',
        'categoryId': 'electronics',
        'color': 'black',
        'createdAt': DateTime.now(),
        'description': 'Smartwatch with health monitoring and GPS',
        'discount': '10%',
        'icon': 'watch',
        'images': [
          'https://example.com/watch1.jpg',
          'https://example.com/watch2.jpg'
        ],
        'name': 'Apple Watch Series 7',
        'originalPrice': 'AED 1,599',
        'price': 1439.0,
        'rating': 4.7,
        'reviews': 89,
        'specifications': {
          'brand': 'Apple',
          'display': 'Always-On Retina',
          'features': 'Heart Rate Monitor, GPS, Water Resistant',
          'battery': '18 hours'
        },
        'stock': 22,
        'updatedAt': DateTime.now(),
      }
    ];
  }

  // Search products
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products.where((product) {
        final name = product['name'].toString().toLowerCase();
        final description = product['description'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();
        return name.contains(searchQuery) || description.contains(searchQuery);
      }).toList();
    }
    notifyListeners();
  }

  // Filter products by category
  void filterProductsByCategory(String categoryId) {
    if (categoryId.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products.where((product) {
        return product['category_id'] == categoryId;
      }).toList();
    }
    notifyListeners();
  }

  // Get product by ID
  Map<String, dynamic>? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product['id'] == productId);
    } catch (e) {
      return null;
    }
  }

  // ==================== CART ====================

  Future<void> loadUserCart(String userId) async {
    _isLoadingCart = true;
    _cartError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate loading
      final prefs = await SharedPreferences.getInstance();
      final cartData = prefs.getString('cart_$userId');
      if (cartData != null) {
        // Parse cart data (simplified for now)
        _cart = {};
      } else {
        _cart = {};
      }
      _isLoadingCart = false;
      notifyListeners();
    } catch (e) {
      _cartError = e.toString();
      _isLoadingCart = false;
      notifyListeners();
    }
  }

  // Add item to cart
  Future<void> addToCart(String userId, String productId, int quantity) async {
    try {
      final product = getProductById(productId);
      if (product != null) {
        if (_cart.containsKey(productId)) {
          final currentQuantity = _cart[productId]['quantity'] as int;
          _cart[productId]['quantity'] = currentQuantity + quantity;
        } else {
          _cart[productId] = {
            'id': productId,
            'name': product['name'],
            'price': product['price'],
            'quantity': quantity,
            'image': product['image'],
          };
        }
        
        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cart_$userId', _cart.toString());
        
        notifyListeners();
      }
    } catch (e) {
      _cartError = e.toString();
      notifyListeners();
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String userId, String productId) async {
    try {
      _cart.remove(productId);
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart_$userId', _cart.toString());
      
      notifyListeners();
    } catch (e) {
      _cartError = e.toString();
      notifyListeners();
    }
  }

  // Update cart item quantity
  Future<void> updateCartQuantity(String userId, String productId, int quantity) async {
    try {
      if (_cart.containsKey(productId)) {
        if (quantity <= 0) {
          _cart.remove(productId);
        } else {
          _cart[productId]['quantity'] = quantity;
        }
        
        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cart_$userId', _cart.toString());
        
        notifyListeners();
      }
    } catch (e) {
      _cartError = e.toString();
      notifyListeners();
    }
  }

  // Clear cart
  Future<void> clearCart(String userId) async {
    try {
      _cart.clear();
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cart_$userId');
      
      notifyListeners();
    } catch (e) {
      _cartError = e.toString();
      notifyListeners();
    }
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return _cart.containsKey(productId);
  }

  // Get cart item quantity
  int getCartItemQuantity(String productId) {
    if (_cart.containsKey(productId)) {
      return _cart[productId]['quantity'] as int;
    }
    return 0;
  }

  // ==================== ORDERS ====================

  Future<void> loadUserOrders(String userId) async {
    _isLoadingOrders = true;
    _ordersError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
      _orders = List.from(sampleOrders);
      _isLoadingOrders = false;
      notifyListeners();
    } catch (e) {
      _ordersError = e.toString();
      _isLoadingOrders = false;
      notifyListeners();
    }
  }

  // Create order
  Future<void> createOrder(String userId, Map<String, dynamic> orderData) async {
    try {
      final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
      final newOrder = {
        'id': orderId,
        'user_id': userId,
        'items': _cart.values.toList(),
        'total': cartTotal,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
        ...orderData,
      };
      
      _orders.add(newOrder);
      
      // Clear cart after order creation
      await clearCart(userId);
      
      notifyListeners();
    } catch (e) {
      _ordersError = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // ==================== WISHLIST ====================

  Future<void> loadUserWishlist(String userId) async {
    _isLoadingWishlist = true;
    _wishlistError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate loading
      final prefs = await SharedPreferences.getInstance();
      final wishlistData = prefs.getStringList('wishlist_$userId') ?? [];
      _wishlist = wishlistData;
      _isLoadingWishlist = false;
      notifyListeners();
    } catch (e) {
      _wishlistError = e.toString();
      _isLoadingWishlist = false;
      notifyListeners();
    }
  }

  // Add to wishlist
  Future<void> addToWishlist(String userId, String productId) async {
    try {
      if (!_wishlist.contains(productId)) {
        _wishlist.add(productId);
        
        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('wishlist_$userId', _wishlist);
        
        notifyListeners();
      }
    } catch (e) {
      _wishlistError = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // Remove from wishlist
  Future<void> removeFromWishlist(String userId, String productId) async {
    try {
      _wishlist.remove(productId);
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('wishlist_$userId', _wishlist);
      
      notifyListeners();
    } catch (e) {
      _wishlistError = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // Check if product is in wishlist
  bool isInWishlist(String productId) {
    return _wishlist.contains(productId);
  }

  // ==================== CATEGORIES ====================

  Future<void> loadCategories() async {
    _isLoadingCategories = true;
    _categoriesError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate loading
      _categories = List.from(sampleCategories);
      _isLoadingCategories = false;
      notifyListeners();
    } catch (e) {
      _categoriesError = e.toString();
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  // ==================== UTILITIES ====================

  // Clear all data (for logout)
  void clearAllData() {
    _products = [];
    _filteredProducts = [];
    _cart = {};
    _orders = [];
    _wishlist = [];
    _categories = [];
    
    _isLoadingProducts = false;
    _isLoadingCart = false;
    _isLoadingOrders = false;
    _isLoadingWishlist = false;
    _isLoadingCategories = false;
    
    _productsError = null;
    _cartError = null;
    _ordersError = null;
    _wishlistError = null;
    _categoriesError = null;
    
    notifyListeners();
  }
}
