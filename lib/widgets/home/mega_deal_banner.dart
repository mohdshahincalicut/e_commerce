import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MegaDealBanner extends StatelessWidget {
  const MegaDealBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange[400]!,
            Colors.orange[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Super MEGA DEAL Title
          Text(
            'Super MEGA DEAL',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Jewelry Images Row
          Row(
            children: [
              Expanded(
                child: _buildJewelryItem('Necklace', Icons.diamond),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildJewelryItem('Earrings', Icons.earbuds),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildJewelryItem('Ring', Icons.circle),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildJewelryItem('Bracelet', Icons.circle_outlined),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Promotional Text
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly 30 Posters Rs - 999 only /-',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'TODAY GOLD & SILVER RATE',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Click Here Button
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Click Here',
                style: TextStyle(
                  color: Colors.orange[600],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJewelryItem(String name, IconData icon) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32.sp,
            color: Colors.white,
          ),
          SizedBox(height: 4.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
