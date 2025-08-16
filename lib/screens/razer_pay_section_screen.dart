import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RazerPaySectionScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final int quantity;
  final double totalAmount;

  const RazerPaySectionScreen({
    super.key,
    required this.product,
    required this.quantity,
    required this.totalAmount,
  });

  @override
  State<RazerPaySectionScreen> createState() => _RazerPaySectionScreenState();
}

class _RazerPaySectionScreenState extends State<RazerPaySectionScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple[800]!,
              Colors.deepPurple[600]!,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Payment Icon
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.payment,
                    size: 60.sp,
                    color: Colors.deepPurple[800],
                  ),
                ),
                
                SizedBox(height: 30.h),
                
                // Title
                Text(
                  'Payment Gateway',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(height: 10.h),
                
                // Subtitle
                Text(
                  'Secure Payment Processing',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                
                SizedBox(height: 40.h),
                
                // Order Summary
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Product:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            widget.product['name'] as String? ?? 'Product',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${widget.quantity}x',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[800],
                            ),
                          ),
                          Text(
                            'AED ${widget.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 30.h),
                
                // Payment Button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.deepPurple[800]!,
                              ),
                            ),
                          )
                        : Text(
                            'Pay AED ${widget.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                SizedBox(height: 20.h),
                
                // Security Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.security,
                      size: 16.sp,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Secure Payment Gateway',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment successful! Order ID: ${DateTime.now().millisecondsSinceEpoch}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate back
    Navigator.pop(context);
  }
}
