import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

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
            Colors.deepPurple[400]!,
            Colors.deepPurple[600]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Logo and Phone
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo Placeholder
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.shopping_bag,
                  size: 24.sp,
                  color: Colors.white,
                ),
              ),
              
              // Contact Info
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 14.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '+91 88070 57825',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Main Title
          Text(
            'Premium Shopping\nExperience',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Features List
          Column(
            children: [
              _buildFeature('Free Delivery on Orders Above ₹499'),
              _buildFeature('24/7 Customer Support'),
              _buildFeature('Secure Payment Options'),
              _buildFeature('Easy Returns & Refunds'),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Bottom Section with Offer and Action
          Row(
            children: [
              // Special Offer
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Special Offer',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Get 20% OFF',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Shop Now',
                        style: TextStyle(
                          color: Colors.deepPurple[600],
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: 16.w),
              
              // Shopping Icons
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    _buildShoppingIcon('Mobile', Icons.phone_android, 0.8),
                    SizedBox(width: 8.w),
                    _buildShoppingIcon('Laptop', Icons.laptop, 0.6),
                    SizedBox(width: 8.w),
                    _buildShoppingIcon('Tablet', Icons.tablet, 0.4),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16.sp,
            color: Colors.white,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingIcon(String device, IconData icon, double scale) {
    return Column(
      children: [
        Container(
          width: 40.w * scale,
          height: 30.h * scale,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: Icon(
            icon,
            size: 16.sp * scale,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          device,
          style: TextStyle(
            fontSize: 8.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
