import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Products
  Stream<List<Map<String, dynamic>>> getProducts() {
    try {
      return _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList());
    } catch (e) {
      print('Error getting products: $e');
      return Stream.value([]);
    }
  }

  Future<Map<String, dynamic>?> getProduct(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    try {
      await _firestore.collection('products').add(product);
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('products').doc(productId).update(data);
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }

  // Users
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> saveUserData(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Cart (Realtime Database)
  Stream<Map<String, dynamic>> getUserCart(String userId) {
    try {
      return _database
          .ref('carts/$userId')
          .onValue
          .map((event) {
            if (event.snapshot.value != null) {
              return Map<String, dynamic>.from(event.snapshot.value as Map);
            }
            return <String, dynamic>{};
          });
    } catch (e) {
      print('Error getting user cart: $e');
      return Stream.value(<String, dynamic>{});
    }
  }

  Future<void> addToCart(String userId, String productId, Map<String, dynamic> item) async {
    try {
      await _database.ref('carts/$userId/$productId').set(item);
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  Future<void> updateCartItemQuantity(String userId, String productId, int quantity) async {
    try {
      if (quantity <= 0) {
        await _database.ref('carts/$userId/$productId').remove();
      } else {
        await _database.ref('carts/$userId/$productId/quantity').set(quantity);
      }
    } catch (e) {
      print('Error updating cart item quantity: $e');
      rethrow;
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    try {
      await _database.ref('carts/$userId/$productId').remove();
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }

  Future<void> clearCart(String userId) async {
    try {
      await _database.ref('carts/$userId').remove();
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }

  // Orders
  Future<void> createOrder(String userId, Map<String, dynamic> order) async {
    try {
      await _firestore.collection('orders').add({
        ...order,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getUserOrders(String userId) {
    try {
      return _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList());
    } catch (e) {
      print('Error getting user orders: $e');
      return Stream.value([]);
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  // Wishlist
  Stream<List<String>> getUserWishlist(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
    } catch (e) {
      print('Error getting user wishlist: $e');
      return Stream.value([]);
    }
  }

  Future<void> addToWishlist(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .set({'addedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      print('Error adding to wishlist: $e');
      rethrow;
    }
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .delete();
    } catch (e) {
      print('Error removing from wishlist: $e');
      rethrow;
    }
  }

  // Reviews
  Stream<List<Map<String, dynamic>>> getProductReviews(String productId) {
    try {
      return _firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList());
    } catch (e) {
      print('Error getting product reviews: $e');
      return Stream.value([]);
    }
  }

  Future<void> addProductReview(String productId, Map<String, dynamic> review) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .add({
        ...review,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding product review: $e');
      rethrow;
    }
  }

  // Categories
  Stream<List<Map<String, dynamic>>> getCategories() {
    try {
      return _firestore
          .collection('categories')
          .orderBy('name')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList());
    } catch (e) {
      print('Error getting categories: $e');
      return Stream.value([]);
    }
  }

  Stream<List<Map<String, dynamic>>> getProductsByCategory(String categoryId) {
    try {
      return _firestore
          .collection('products')
          .where('categoryId', isEqualTo: categoryId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList());
    } catch (e) {
      print('Error getting products by category: $e');
      return Stream.value([]);
    }
  }

  // Search
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + '\uf8ff')
          .get();
      
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  // Analytics
  Future<void> trackProductView(String productId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('analytics').add({
          'type': 'product_view',
          'productId': productId,
          'userId': userId,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error tracking product view: $e');
    }
  }

  Future<void> trackPurchase(String orderId, double total) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('analytics').add({
          'type': 'purchase',
          'orderId': orderId,
          'userId': userId,
          'total': total,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error tracking purchase: $e');
    }
  }
}
