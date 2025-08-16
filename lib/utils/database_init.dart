import 'package:shared_preferences/shared_preferences.dart';
import 'sample_data.dart';

class DatabaseInit {
  // Mock database initialization without Firebase
  static Future<void> initializeIfEmpty() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isInitialized = prefs.getBool('database_initialized') ?? false;
      
      if (!isInitialized) {
        // Simulate database initialization
        await Future.delayed(const Duration(seconds: 1));
        
        // Mark as initialized
        await prefs.setBool('database_initialized', true);
        print('Mock database initialized successfully');
      }
    } catch (e) {
      print('Database initialization error: $e');
    }
  }

  // Get database stats
  static Future<Map<String, dynamic>> getDatabaseStats() async {
    return {
      'products_count': sampleProducts.length,
      'categories_count': sampleCategories.length,
      'users_count': sampleUsers.length,
      'orders_count': sampleOrders.length,
      'reviews_count': sampleReviews.length,
    };
  }

  // Check if database is empty
  static Future<bool> isDatabaseEmpty() async {
    return false; // Always return false since we have sample data
  }

  // Clear all data
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print('All data cleared successfully');
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}


