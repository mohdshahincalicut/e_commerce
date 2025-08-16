import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({super.key});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _selectedIndex = 0;

  final List<BottomNavItem> _items = [
    BottomNavItem(
      icon: Icons.home,
      label: 'Home',
      isSelected: true,
    ),
    BottomNavItem(
      icon: Icons.local_offer,
      label: 'Coupons',
      isSelected: false,
    ),
    BottomNavItem(
      icon: Icons.thumb_up,
      label: 'Likes',
      isSelected: false,
    ),
    BottomNavItem(
      icon: Icons.person,
      label: 'Profile',
      isSelected: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildNavItem(index, item);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, BottomNavItem item) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _handleNavigation(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 24.sp,
            color: isSelected ? Colors.deepPurple[800] : Colors.grey[600],
          ),
          SizedBox(height: 4.h),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected ? Colors.deepPurple[800] : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0: // Home
        // Already on home page
        break;
      case 1: // Coupons
        _showComingSoonDialog('Coupons');
        break;
      case 2: // Likes
        _showComingSoonDialog('Likes');
        break;
      case 3: // Profile
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Coming Soon!'),
        content: Text('$feature feature will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;
  final bool isSelected;

  BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });
}
