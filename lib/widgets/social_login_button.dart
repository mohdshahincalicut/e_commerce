import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;
  final String label;

  const SocialLoginButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon placeholder - you can replace with actual icons
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: _getIconColor(),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    _getIconData(),
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getIconColor() {
    return const Color(0xFF4285F4); // Google blue
  }

  IconData _getIconData() {
    return Icons.g_mobiledata; // Placeholder for Google icon
  }
}
