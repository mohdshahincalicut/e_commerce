import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../screens/cart_screen.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  static const double _shadowOpacity = 0.05;
  static const double _shadowBlurRadius = 4.0;
  static const Offset _shadowOffset = Offset(0, 2);
  static const double _iconSize = 24.0;
  static const double _actionIconSize = 20.0;
  static const double _containerBorderRadius = 8.0;
  static const double _spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: _buildContainerDecoration(),
      child: Row(
        children: [
          _buildHamburgerMenu(context),
          const Spacer(),
          _buildActionIcons(context),
        ],
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: _shadowOpacity),
          blurRadius: _shadowBlurRadius,
          offset: _shadowOffset,
        ),
      ],
    );
  }

  Widget _buildHamburgerMenu(BuildContext context) {
    return IconButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
      icon: Icon(
        Icons.menu,
        size: _iconSize.sp,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildActionIcons(BuildContext context) {
    return Row(
      children: [
        _buildActionIcon(Icons.notifications_outlined, () {}),
        SizedBox(width: _spacing.w),
        _buildActionIcon(Icons.favorite_border, () {}),
        SizedBox(width: _spacing.w),
        _buildActionIcon(Icons.location_on_outlined, () {}),
        SizedBox(width: _spacing.w),
        _buildCartIcon(context),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(_spacing.w),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(_containerBorderRadius.r),
        ),
        child: Icon(
          icon,
          size: _actionIconSize.sp,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return GestureDetector(
          onTap: () => _navigateToCart(context),
          child: Container(
            padding: EdgeInsets.all(_spacing.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(_containerBorderRadius.r),
            ),
            child: Stack(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: _actionIconSize.sp,
                  color: Colors.grey[700],
                ),
                if (cartProvider.totalQuantity > 0)
                  _buildCartBadge(cartProvider.totalQuantity),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }

  Widget _buildCartBadge(int quantity) {
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.r),
        ),
        constraints: BoxConstraints(
          minWidth: 16.w,
          minHeight: 16.h,
        ),
        child: Text(
          '$quantity',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }


}
