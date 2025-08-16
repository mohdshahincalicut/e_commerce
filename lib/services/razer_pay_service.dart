// ignore_for_file: unused_field

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazerPayService {
  // Replace with your actual Razorpay credentials
  static const String _apiKey = 'YOUR_RAZORPAY_API_KEY';
  static const String _secretKey = 'YOUR_RAZORPAY_SECRET_KEY';
  static const String _baseUrl = 'https://api.razorpay.com/v1';
  
  // Test credentials (replace with production credentials)
  static const String _testApiKey = 'rzp_test_YOUR_TEST_KEY';
  static const String _testSecretKey = 'YOUR_TEST_SECRET_KEY';

  /// Create a payment order
  static Future<Map<String, dynamic>> createOrder({
    required double amount,
    required String currency,
    required String receipt,
    required String productName,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/orders');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode('$_testApiKey:$_testSecretKey'))}',
        },
        body: jsonEncode({
          'amount': (amount * 100).toInt(), // Convert to smallest currency unit (paise for INR)
          'currency': currency,
          'receipt': receipt,
          'notes': {
            'product_name': productName,
          },
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating payment order: $e');
    }
  }

  /// Verify payment signature
  static bool verifyPaymentSignature({
    required String orderId,
    required String paymentId,
    required String signature,
  }) {
    try {
      final expectedSignature = _generateSignature(orderId, paymentId);
      return signature == expectedSignature;
    } catch (e) {
      return false;
    }
  }

  /// Generate signature for payment verification
  static String _generateSignature(String orderId, String paymentId) {
    final data = '$orderId|$paymentId';
    return 'mock_signature_${data.hashCode}';
  }

  /// Get payment options for Razorpay
  static Map<String, dynamic> getPaymentOptions({
    required String orderId,
    required double amount,
    required String currency,
    required String productName,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) {
    return {
      'key': _testApiKey,
      'amount': (amount * 100).toInt(),
      'currency': currency,
      'name': 'Your Store Name',
      'description': productName,
      'order_id': orderId,
      'prefill': {
        'name': customerName,
        'email': customerEmail,
        'contact': customerPhone,
      },
      'theme': {
        'color': '#6B46C1', // Purple theme
      },
    };
  }
}

/// Razorpay Payment Handler
class RazorpayPaymentHandler {
  static Razorpay? _razorpay;
  
  /// Initialize Razorpay
  static void initialize() {
    _razorpay = Razorpay();
    _setupEventHandlers();
  }
  
  /// Setup event handlers
  static void _setupEventHandlers() {
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  
  /// Handle payment success
  static void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Success: ${response.paymentId}');
    // Handle success - you can pass this to a callback
  }
  
  /// Handle payment error
  static void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.message}');
    // Handle error - you can pass this to a callback
  }
  
  /// Handle external wallet
  static void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
    // Handle external wallet - you can pass this to a callback
  }
  
  /// Open payment
  static void openPayment(Map<String, dynamic> options) {
    try {
      _razorpay?.open(options);
    } catch (e) {
      print('Error opening payment: $e');
    }
  }
  
  /// Dispose Razorpay
  static void dispose() {
    _razorpay?.clear();
  }
}
