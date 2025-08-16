# Razer Pay Integration Setup Guide

## 🎯 **Overview**

This guide explains how to set up Razer Pay integration in your Flutter e-commerce app for the "Buy Now" functionality.

## ✅ **Features Implemented**

### **1. Payment Processing**
- **Order Creation**: Creates payment orders via Razer Pay API
- **Payment Gateway**: WebView-based payment interface
- **Payment Verification**: Signature verification for security
- **Error Handling**: Comprehensive error management

### **2. User Experience**
- **Loading States**: Shows loading indicators during payment processing
- **Success Feedback**: Confirmation messages for successful payments
- **Error Messages**: Clear error notifications
- **Cancellation Handling**: Graceful handling of payment cancellations

### **3. Integration Points**
- **Product Detail Screen**: "Buy Now" button integration
- **Quantity Support**: Respects selected quantity for payment
- **Price Calculation**: Dynamic total calculation based on quantity
- **Order Management**: Payment order creation and tracking

## 🛠️ **Setup Instructions**

### **Step 1: Razer Pay Account Setup**

1. **Create Razer Pay Account**
   - Visit [Razer Pay Dashboard](https://dashboard.razorpay.com/)
   - Sign up for a merchant account
   - Complete KYC verification

2. **Get API Credentials**
   - Navigate to Settings → API Keys
   - Generate new API key pair
   - Copy the Key ID and Key Secret

3. **Configure Webhook (Optional)**
   - Set up webhook URL for payment notifications
   - Configure events: `payment.captured`, `payment.failed`

### **Step 2: Update API Credentials**

**In `lib/services/razer_pay_service.dart`:**

```dart
// Replace with your actual Razer Pay credentials
static const String _testApiKey = 'rzp_test_YOUR_ACTUAL_TEST_KEY';
static const String _testSecretKey = 'YOUR_ACTUAL_TEST_SECRET_KEY';

// For production
static const String _apiKey = 'rzp_live_YOUR_ACTUAL_LIVE_KEY';
static const String _secretKey = 'YOUR_ACTUAL_LIVE_SECRET_KEY';
```

### **Step 3: Configure Currency**

**Update currency in `_initiateRazerPayPayment` method:**

```dart
// Change to your preferred currency
currency: 'INR', // Options: INR, USD, EUR, etc.
```

### **Step 4: Customize Payment Options**

**Update store details in `getPaymentOptions` method:**

```dart
return {
  'key': _testApiKey,
  'amount': (amount * 100).toInt(),
  'currency': currency,
  'name': 'Your Store Name', // Update this
  'description': productName,
  'order_id': orderId,
  'prefill': {
    'name': customerName, // Get from user profile
    'email': customerEmail, // Get from user profile
    'contact': customerPhone, // Get from user profile
  },
  'theme': {
    'color': '#6B46C1', // Your brand color
  },
};
```

## 🔧 **Configuration Options**

### **1. Payment Methods**
Razer Pay supports multiple payment methods:
- **Credit/Debit Cards**: Visa, MasterCard, American Express
- **Net Banking**: All major Indian banks
- **UPI**: Google Pay, PhonePe, Paytm, etc.
- **Wallets**: Paytm, Mobikwik, etc.
- **EMI**: Credit card EMI options

### **2. Currency Support**
- **INR** (Indian Rupees) - Primary
- **USD** (US Dollars)
- **EUR** (Euros)
- **GBP** (British Pounds)
- **AED** (UAE Dirhams)

### **3. Theme Customization**
```dart
'theme': {
  'color': '#6B46C1', // Primary color
  'backdrop_color': '#F5F5F5', // Background color
  'hide_topbar': false, // Show/hide top bar
},
```

## 📱 **User Flow**

### **1. Payment Initiation**
1. User selects product and quantity
2. Taps "Buy Now" button
3. Loading dialog appears
4. Payment order is created

### **2. Payment Processing**
1. WebView opens with Razer Pay interface
2. User enters payment details
3. Payment is processed securely
4. Success/error response is handled

### **3. Payment Completion**
1. Success: Order confirmation shown
2. Error: Error message displayed
3. Cancel: Cancellation message shown
4. User returns to product detail screen

## 🔒 **Security Features**

### **1. API Security**
- **HTTPS**: All API calls use HTTPS
- **Authentication**: Basic auth with API credentials
- **Signature Verification**: Payment response verification

### **2. Data Protection**
- **No Card Storage**: Card details not stored locally
- **Secure Transmission**: All data encrypted in transit
- **PCI Compliance**: Razer Pay handles PCI compliance

### **3. Error Handling**
- **Network Errors**: Graceful handling of connection issues
- **API Errors**: Clear error messages for users
- **Validation**: Input validation and sanitization

## 🧪 **Testing**

### **1. Test Mode**
- Use test API keys for development
- Test with Razer Pay test cards
- Verify all payment scenarios

### **2. Test Cards**
```
Card Number: 4111 1111 1111 1111
Expiry: Any future date
CVV: Any 3 digits
Name: Any name
```

### **3. Test Scenarios**
- **Successful Payment**: Complete payment flow
- **Failed Payment**: Test error handling
- **Cancelled Payment**: Test cancellation flow
- **Network Issues**: Test offline scenarios

## 🚀 **Production Deployment**

### **1. Live Credentials**
- Replace test keys with live keys
- Update webhook URLs
- Configure production environment

### **2. Monitoring**
- Set up payment monitoring
- Configure error alerts
- Monitor transaction logs

### **3. Compliance**
- Ensure PCI compliance
- Follow local payment regulations
- Implement proper error handling

## 📊 **Analytics & Tracking**

### **1. Payment Analytics**
- Track payment success rates
- Monitor conversion rates
- Analyze payment method preferences

### **2. Error Tracking**
- Log payment failures
- Track user abandonment
- Monitor technical issues

### **3. Business Intelligence**
- Revenue tracking
- Customer behavior analysis
- Payment optimization insights

## 🔧 **Customization Options**

### **1. UI Customization**
```dart
// Custom payment button
ElevatedButton(
  onPressed: () => _initiateRazerPayPayment(product, productId),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
  ),
  child: Text('Pay with Razer Pay'),
)
```

### **2. Payment Flow Customization**
- Add order confirmation screen
- Implement inventory management
- Add email notifications
- Create order tracking system

### **3. Integration Extensions**
- Connect to inventory system
- Integrate with shipping providers
- Add loyalty program integration
- Implement refund processing

## 🆘 **Troubleshooting**

### **Common Issues**

1. **API Key Errors**
   - Verify API credentials
   - Check key permissions
   - Ensure correct environment (test/live)

2. **Payment Failures**
   - Check network connectivity
   - Verify payment method
   - Review error logs

3. **WebView Issues**
   - Ensure JavaScript is enabled
   - Check WebView permissions
   - Verify HTML rendering

### **Debug Mode**
```dart
// Enable debug logging
print('Payment Options: $paymentOptions');
print('Order Response: $orderResponse');
print('Payment Response: $response');
```

## 📞 **Support**

### **Razer Pay Support**
- **Documentation**: [Razer Pay Docs](https://razorpay.com/docs/)
- **API Reference**: [API Documentation](https://razorpay.com/docs/api/)
- **Support**: [Contact Support](https://razorpay.com/support/)

### **Flutter Integration**
- **WebView**: [WebView Flutter](https://pub.dev/packages/webview_flutter)
- **HTTP**: [HTTP Package](https://pub.dev/packages/http)

The Razer Pay integration is now complete! 🎉

**Test the payment flow by tapping the "Buy Now" button on any product detail screen.**
