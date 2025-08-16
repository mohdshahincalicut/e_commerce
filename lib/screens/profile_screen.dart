import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get current timestamp for last update
    final now = DateTime.now();
    final lastUpdate = prefs.getString('user_last_update');
    
    // If no last update exists, set it to now
    if (lastUpdate == null) {
      await prefs.setString('user_last_update', now.toIso8601String());
    }
    
    setState(() {
      _userData = {
        'id': prefs.getString('user_id') ?? prefs.getString('mock_user_id') ?? 'mock_uid',
        'email': prefs.getString('user_email') ?? prefs.getString('mock_user_email') ?? 'mock@example.com',
        'name': prefs.getString('user_name') ?? prefs.getString('mock_user_name') ?? 'Mock User',
        'phone': '+91 98765 43210',
        'address': 'Mumbai, Maharashtra, India',
        'joinDate': 'January 2024',
        'lastUpdate': lastUpdate ?? now.toIso8601String(),
      };
    });
  }

  Future<void> _updateLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    await prefs.setString('user_last_update', now);
    
    setState(() {
      _userData?['lastUpdate'] = now;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.grey[800]),
            onPressed: () async {
              await _updateLastUpdateTime();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile updated!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            
            SizedBox(height: 16.h),
            
            // Quick Stats
            _buildQuickStats(),
            
            SizedBox(height: 16.h),
            
            // Profile Sections
            _buildProfileSections(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.deepPurple[100],
            child: Icon(
              Icons.person,
              size: 50.sp,
              color: Colors.deepPurple[800],
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // User Name
          Text(
            _userData?['name'] ?? 'User Name',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          
          SizedBox(height: 4.h),
          
          // User Email
          Text(
            _userData?['email'] ?? 'user@example.com',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // Last Update Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.deepPurple[50],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              _getLastUpdateText(),
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.deepPurple[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.shopping_bag,
              title: 'Orders',
              value: '12',
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.favorite,
              title: 'Wishlist',
              value: '8',
              color: Colors.red,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.local_offer,
              title: 'Coupons',
              value: '5',
              color: Colors.orange,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.star,
              title: 'Reviews',
              value: '3',
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            size: 24.sp,
            color: color,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSections() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // Personal Information
          _buildSectionCard(
            title: 'Personal Information',
            icon: Icons.person_outline,
            children: [
              _buildInfoRow('Name', _userData?['name'] ?? 'User Name'),
              _buildInfoRow('Email', _userData?['email'] ?? 'user@example.com'),
              _buildInfoRow('Phone', _userData?['phone'] ?? '+91 98765 43210'),
              _buildInfoRow('Address', _userData?['address'] ?? 'Mumbai, India'),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Account Settings
          _buildSectionCard(
            title: 'Account Settings',
            icon: Icons.settings,
            children: [
              _buildSettingItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage your notifications',
                onTap: () => _showComingSoonDialog('Notifications'),
              ),
              _buildSettingItem(
                icon: Icons.lock_outline,
                title: 'Privacy & Security',
                subtitle: 'Manage your privacy settings',
                onTap: () => _showComingSoonDialog('Privacy & Security'),
              ),
              _buildSettingItem(
                icon: Icons.payment,
                title: 'Payment Methods',
                subtitle: 'Manage your payment options',
                onTap: () => _showComingSoonDialog('Payment Methods'),
              ),
              _buildSettingItem(
                icon: Icons.location_on_outlined,
                title: 'Addresses',
                subtitle: 'Manage your delivery addresses',
                onTap: () => _showComingSoonDialog('Addresses'),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Shopping
          _buildSectionCard(
            title: 'Shopping',
            icon: Icons.shopping_bag_outlined,
            children: [
              _buildSettingItem(
                icon: Icons.shopping_cart_outlined,
                title: 'My Orders',
                subtitle: 'View your order history',
                onTap: () => _showComingSoonDialog('My Orders'),
              ),
              _buildSettingItem(
                icon: Icons.favorite_border,
                title: 'My Wishlist',
                subtitle: 'View your saved items',
                onTap: () => _showComingSoonDialog('My Wishlist'),
              ),
              _buildSettingItem(
                icon: Icons.local_offer_outlined,
                title: 'My Coupons',
                subtitle: 'View your available coupons',
                onTap: () => _showComingSoonDialog('My Coupons'),
              ),
              _buildSettingItem(
                icon: Icons.star_outline,
                title: 'My Reviews',
                subtitle: 'View your product reviews',
                onTap: () => _showComingSoonDialog('My Reviews'),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Support & Help
          _buildSectionCard(
            title: 'Support & Help',
            icon: Icons.help_outline,
            children: [
              _buildSettingItem(
                icon: Icons.headset_mic_outlined,
                title: 'Customer Support',
                subtitle: 'Get help from our team',
                onTap: () => _showComingSoonDialog('Customer Support'),
              ),
              _buildSettingItem(
                icon: Icons.question_answer_outlined,
                title: 'FAQs',
                subtitle: 'Frequently asked questions',
                onTap: () => _showComingSoonDialog('FAQs'),
              ),
              _buildSettingItem(
                icon: Icons.info_outline,
                title: 'About Us',
                subtitle: 'Learn more about our company',
                onTap: () => _showComingSoonDialog('About Us'),
              ),
              _buildSettingItem(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                subtitle: 'Read our terms and conditions',
                onTap: () => _showComingSoonDialog('Terms & Conditions'),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Logout Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Clear cart
                        cartProvider.clear();
                        
                        // Sign out
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.signOut();
                        
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      icon: Icon(Icons.logout),
                      label: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'App Version 1.0.0',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.deepPurple[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20.sp,
                  color: Colors.deepPurple[800],
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[800],
                  ),
                ),
              ],
            ),
          ),
          
          // Section Content
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: Colors.grey[700],
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  String _getLastUpdateText() {
    final lastUpdate = _userData?['lastUpdate'];
    if (lastUpdate == null) {
      return 'Never updated';
    }
    
    try {
      final lastUpdateDate = DateTime.parse(lastUpdate);
      final now = DateTime.now();
      final difference = now.difference(lastUpdateDate);

      if (difference.inDays > 365) {
        return 'Last updated ${(difference.inDays / 365).floor()} years ago';
      } else if (difference.inDays > 30) {
        return 'Last updated ${(difference.inDays / 30).floor()} months ago';
      } else if (difference.inDays > 0) {
        return 'Last updated ${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return 'Last updated ${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return 'Last updated ${difference.inMinutes} minutes ago';
      } else {
        return 'Last updated just now';
      }
    } catch (e) {
      return 'Last updated recently';
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
