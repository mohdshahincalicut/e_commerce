import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Magnifying Glass Icon
          Icon(
            Icons.search,
            size: 20.sp,
            color: Colors.grey[600],
          ),
          
          SizedBox(width: 12.w),
          
          // Search Text
          Expanded(
            child: Text(
              'Search',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16.sp,
              ),
            ),
          ),
          
          // Microphone Icon
          GestureDetector(
            onTap: () {
              // Handle voice search
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.mic,
                size: 18.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
