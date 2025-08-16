import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../widgets/home/header_widget.dart';
import '../widgets/home/search_bar_widget.dart';
import '../widgets/home/mega_deal_banner.dart';
import '../widgets/home/featured_section.dart';
import '../widgets/home/product_grid.dart';
import '../widgets/common/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String>? _mockUserData;
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userIdKey = 'user_id';
  static const String _mockUserPrefix = 'mock_user_';

  @override
  void initState() {
    super.initState();
    _loadMockUserData();
  }

  Future<void> _loadMockUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_userIdKey);
      
      if (userId != null && userId.startsWith(_mockUserPrefix)) {
        if (mounted) {
          setState(() {
            _mockUserData = {
              'email': prefs.getString(_userEmailKey) ?? 'N/A',
              'name': prefs.getString(_userNameKey) ?? 'N/A',
              'id': userId,
            };
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading mock user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),
            const SearchBarWidget(),
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: 80.h,
      ),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          const MegaDealBanner(),
          SizedBox(height: 24.h),
          const FeaturedSection(),
          SizedBox(height: 24.h),
          const ProductGrid(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          ..._buildDrawerItems(context),
          const Divider(),
          _buildLogoutItem(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple[900]!,
            Colors.deepPurple[800]!,
            Colors.deepPurple[400]!,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 30.sp,
              color: Colors.deepPurple[800],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            _mockUserData?['name'] ?? 'User',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _mockUserData?['email'] ?? 'user@example.com',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    final drawerItems = [
      {'icon': Icons.home, 'title': 'Home'},
      {'icon': Icons.category, 'title': 'Categories'},
      {'icon': Icons.favorite, 'title': 'Favorites'},
      {'icon': Icons.shopping_cart, 'title': 'Cart'},
      {'icon': Icons.local_offer, 'title': 'Offers'},
      {'icon': Icons.settings, 'title': 'Settings'},
    ];

    return drawerItems.map((item) => _buildDrawerItem(
      icon: item['icon'] as IconData,
      title: item['title'] as String,
      onTap: () {
        Navigator.pop(context);
        // Handle navigation for each item
      },
    )).toList();
  }

  Widget _buildLogoutItem(BuildContext context) {
    return _buildDrawerItem(
      icon: Icons.logout,
      title: 'Logout',
      onTap: () async {
        Navigator.pop(context);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.signOut();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      isLogout: true,
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Colors.grey[700],
        size: 24.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.grey[800],
          fontSize: 16.sp,
          fontWeight: isLogout ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
