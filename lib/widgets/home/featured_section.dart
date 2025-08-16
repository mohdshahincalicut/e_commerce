import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Sort and Filter buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'All Featured',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Row(
              children: [
                _buildActionButton('Sort', Icons.swap_vert),
                SizedBox(width: 8.w),
                _buildActionButton('Filter', Icons.filter_list),
              ],
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Category Icons
        SizedBox(
          height: 100.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCategoryItem('Fashions', Icons.checkroom, Colors.pink),
              SizedBox(width: 16.w),
              _buildCategoryItem('Food & Dining', Icons.restaurant, Colors.orange),
              SizedBox(width: 16.w),
              _buildCategoryItem('Home & Living', Icons.home, Colors.green),
              SizedBox(width: 16.w),
              _buildCategoryItem('Electrical Appliances', Icons.electrical_services, Colors.blue),
              SizedBox(width: 16.w),
              _buildCategoryItem('Beauty & Health', Icons.face, Colors.purple),
              SizedBox(width: 16.w),
              _buildCategoryItem('Sports & Fitness', Icons.fitness_center, Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: Colors.grey[600],
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String name, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(
            icon,
            size: 28.sp,
            color: color,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
