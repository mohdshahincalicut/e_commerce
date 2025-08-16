import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const double _emptyCartIconSize = 120.0;
  static const double _emptyCartIconInnerSize = 60.0;
  static const double _buttonBorderRadius = 25.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return _buildEmptyCart(context);
          }
          return _buildCartContent(context, cartProvider);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.shopping_cart, color: Colors.white),
          SizedBox(width: 8.w),
          Text('Shopping Cart'),
        ],
      ),
      backgroundColor: Colors.deepPurple[800],
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmptyCartIcon(),
          SizedBox(height: 24.h),
          _buildEmptyCartText(),
          SizedBox(height: 32.h),
          _buildContinueShoppingButton(context),
        ],
      ),
    );
  }

  Widget _buildEmptyCartIcon() {
    return Container(
      width: _emptyCartIconSize.w,
      height: _emptyCartIconSize.h,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(_emptyCartIconSize.r / 2),
      ),
      child: Icon(
        Icons.shopping_cart_outlined,
        size: _emptyCartIconInnerSize.sp,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildEmptyCartText() {
    return Column(
      children: [
        Text(
          'Your cart is empty',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Add some products to get started',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueShoppingButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonBorderRadius.r),
        ),
      ),
      child: Text(
        'Continue Shopping',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartProvider cartProvider) {
    return Column(
      children: [
        // Cart Items List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: cartProvider.items.length,
            itemBuilder: (context, index) {
              final item = cartProvider.items.values.toList()[index];
              return _buildCartItem(context, item, cartProvider);
            },
          ),
        ),
        
        // Bottom Section with Total and Actions
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Total Section
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Items:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${cartProvider.totalQuantity}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'AED ${cartProvider.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Action Buttons
              Row(
                children: [
                  // Clear Cart Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _showClearCartDialog(context, cartProvider);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Clear Cart',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 12.w),
                  
                  // Checkout Button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        _proceedToCheckout(context, cartProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[800],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item, CartProvider cartProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image/Icon
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.shopping_bag,
              color: item.color,
              size: 24.sp,
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'AED ${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple[800],
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity Controls
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (item.quantity > 1) {
                        cartProvider.removeItem(item.id);
                      }
                    },
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: item.quantity > 1 ? Colors.red : Colors.grey[400],
                      size: 20.sp,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      cartProvider.addItem(
                        item.id,
                        item.name,
                        item.price,
                        item.image,
                        item.color,
                      );
                    },
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                'AED ${(item.price * item.quantity).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          SizedBox(width: 8.w),
          
          // Remove Button
          IconButton(
            onPressed: () {
              _showRemoveItemDialog(context, cartProvider, item);
            },
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cart'),
        content: Text('Are you sure you want to clear all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cartProvider.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cart cleared successfully!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showRemoveItemDialog(BuildContext context, CartProvider cartProvider, CartItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Item'),
        content: Text('Are you sure you want to remove "${item.name}" from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cartProvider.removeItem(item.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item removed from cart'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout(BuildContext context, CartProvider cartProvider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proceeding to checkout...'),
        backgroundColor: Colors.green,
      ),
    );
    // Here you can navigate to checkout screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
  }
}
