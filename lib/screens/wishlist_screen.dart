import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/database_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/product_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWishlist();
    });
  }

  Future<void> _loadWishlist() async {
    final userId = context.read<AuthProvider>().currentUser?['user_id'];
    if (userId != null) {
      await context.read<DatabaseProvider>().loadUserWishlist(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'My Wishlist',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        actions: [
          Consumer<DatabaseProvider>(
            builder: (context, databaseProvider, child) {
              if (databaseProvider.wishlist.isNotEmpty) {
                return TextButton(
                  onPressed: () => _showClearWishlistDialog(context),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, databaseProvider, child) {
          if (databaseProvider.isLoadingWishlist) {
            return _buildLoadingState();
          }

          if (databaseProvider.wishlistError != null) {
            return _buildErrorState(databaseProvider.wishlistError!);
          }

          if (databaseProvider.wishlist.isEmpty) {
            return _buildEmptyState();
          }

          return _buildWishlistContent(databaseProvider);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            height: 120.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.red[300],
          ),
          SizedBox(height: 16.h),
          Text(
            'Failed to load wishlist',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadWishlist,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start adding products to your wishlist\nby tapping the heart icon on any product',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple[800],
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
            child: Text(
              'Start Shopping',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistContent(DatabaseProvider databaseProvider) {
    final wishlistProducts = databaseProvider.products
        .where((product) => databaseProvider.wishlist.contains(product['id']))
        .toList();

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: wishlistProducts.length,
      itemBuilder: (context, index) {
        final product = wishlistProducts[index];
        return _WishlistItemCard(
          product: product,
          onRemove: () => _removeFromWishlist(product['id']),
          onAddToCart: () => _addToCart(product),
        );
      },
    );
  }

  Future<void> _removeFromWishlist(String productId) async {
    final userId = context.read<AuthProvider>().currentUser?['user_id'];
    if (userId != null) {
      await context.read<DatabaseProvider>().removeFromWishlist(userId, productId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from wishlist'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addToCart(Map<String, dynamic> product) {
    final cartProvider = context.read<CartProvider>();
    final productId = product['id'] as String;
    final productName = product['name'] as String? ?? 'Product';
    final productPrice = (product['price'] as num?)?.toDouble() ?? 0.0;
    
    // Get image URL
    String imageUrl;
    if (product['images'] is List && (product['images'] as List).isNotEmpty) {
      imageUrl = product['images'][0] as String;
    } else {
      imageUrl = _getProductImage(product['icon'] ?? 'default');
    }
    
    final productColor = _getProductColor(product['color'] ?? 'blue');

    cartProvider.addItem(
      productId,
      productName,
      productPrice,
      imageUrl,
      productColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName added to cart!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart screen
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }

  void _showClearWishlistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Clear Wishlist',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to remove all items from your wishlist?',
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _clearWishlist();
              },
              child: Text(
                'Clear All',
                style: TextStyle(color: Colors.red[600]),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearWishlist() async {
    final userId = context.read<AuthProvider>().currentUser?['user_id'];
    if (userId != null) {
      final databaseProvider = context.read<DatabaseProvider>();
      for (String productId in databaseProvider.wishlist) {
        await databaseProvider.removeFromWishlist(userId, productId);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wishlist cleared'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Color _getProductColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      case 'teal':
        return Colors.teal;
      case 'indigo':
        return Colors.indigo;
      case 'pink':
        return Colors.pink;
      case 'cyan':
        return Colors.cyan;
      case 'amber':
        return Colors.amber;
      case 'black':
        return Colors.black87;
      case 'titanium':
        return Colors.grey[400]!;
      case 'space gray':
        return Colors.grey[700]!;
      case 'midnight':
        return Colors.grey[900]!;
      case 'white':
        return Colors.grey[100]!;
      case 'natural':
        return Colors.brown[300]!;
      case 'gold':
        return Colors.amber[300]!;
      case 'silver':
        return Colors.grey[300]!;
      default:
        return Colors.blue;
    }
  }

  String _getProductImage(String imageName) {
    switch (imageName.toLowerCase()) {
      case 'headphones':
        return 'assets/images/products/headphones.png';
      case 'watch':
        return 'assets/images/products/watch.png';
      case 'speaker':
        return 'assets/images/products/speaker.png';
      case 'phone':
      case 'phone_android':
      case 'phone_iphone':
        return 'assets/images/products/phone.png';
      case 'laptop':
        return 'assets/images/products/laptop.png';
      case 'mouse':
        return 'assets/images/products/mouse.png';
      case 'keyboard':
        return 'assets/images/products/keyboard.png';
      case 'camera':
      case 'camera_alt':
      case 'videocam':
        return 'assets/images/products/camera.png';
      case 'battery':
      case 'usb':
      case 'devices':
      case 'sports_esports':
      default:
        return 'assets/images/products/default.png';
    }
  }
}

class _WishlistItemCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const _WishlistItemCard({
    required this.product,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final productName = product['name'] as String? ?? 'Product';
    final productPrice = (product['price'] as num?)?.toDouble() ?? 0.0;
    final originalPrice = (product['originalPrice'] as num?)?.toDouble() ?? 0.0;
    final rating = (product['rating'] as num?)?.toDouble() ?? 0.0;
    final reviews = (product['reviews'] as num?)?.toInt() ?? 0;
    final productColor = _getProductColor(product['color'] ?? 'blue');
    
    // Calculate discount
    int discount = 0;
    if (product['discount'] is String) {
      final discountStr = product['discount'] as String;
      discount = int.tryParse(discountStr.replaceAll('%', '')) ?? 0;
    } else if (originalPrice > 0 && productPrice > 0) {
      discount = ((originalPrice - productPrice) / originalPrice * 100).round();
    }
    
    // Get image URL
    String imageUrl;
    if (product['images'] is List && (product['images'] as List).isNotEmpty) {
      imageUrl = product['images'][0] as String;
    } else {
      imageUrl = _getProductImage(product['icon'] ?? 'default');
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: imageUrl.startsWith('http')
                      ? Image.network(
                          imageUrl,
                          width: 60.sp,
                          height: 60.sp,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.shopping_bag,
                              size: 40.sp,
                              color: productColor,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                color: productColor,
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          imageUrl,
                          width: 60.sp,
                          height: 60.sp,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.shopping_bag,
                              size: 40.sp,
                              color: productColor,
                            );
                          },
                        ),
                ),
                // Discount Badge
                if (discount > 0)
                  Positioned(
                    top: 4.h,
                    left: 4.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        '$discount%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Product Info
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 4.h),
                  
                  // Rating
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (starIndex) {
                          if (starIndex < rating.floor()) {
                            return Icon(
                              Icons.star,
                              size: 14.sp,
                              color: Colors.amber,
                            );
                          } else if (starIndex == rating.floor() && rating % 1 > 0) {
                            return Icon(
                              Icons.star_half,
                              size: 14.sp,
                              color: Colors.amber,
                            );
                          } else {
                            return Icon(
                              Icons.star_border,
                              size: 14.sp,
                              color: Colors.amber,
                            );
                          }
                        }),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '($reviews)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Price
                  Row(
                    children: [
                      Text(
                        'AED ${productPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800],
                        ),
                      ),
                      if (originalPrice > productPrice) ...[
                        SizedBox(width: 8.w),
                        Text(
                          'AED ${originalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAddToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple[800],
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                          ),
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      IconButton(
                        onPressed: onRemove,
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red[600],
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProductColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      case 'teal':
        return Colors.teal;
      case 'indigo':
        return Colors.indigo;
      case 'pink':
        return Colors.pink;
      case 'cyan':
        return Colors.cyan;
      case 'amber':
        return Colors.amber;
      case 'black':
        return Colors.black87;
      case 'titanium':
        return Colors.grey[400]!;
      case 'space gray':
        return Colors.grey[700]!;
      case 'midnight':
        return Colors.grey[900]!;
      case 'white':
        return Colors.grey[100]!;
      case 'natural':
        return Colors.brown[300]!;
      case 'gold':
        return Colors.amber[300]!;
      case 'silver':
        return Colors.grey[300]!;
      default:
        return Colors.blue;
    }
  }

  String _getProductImage(String imageName) {
    switch (imageName.toLowerCase()) {
      case 'headphones':
        return 'assets/images/products/headphones.png';
      case 'watch':
        return 'assets/images/products/watch.png';
      case 'speaker':
        return 'assets/images/products/speaker.png';
      case 'phone':
      case 'phone_android':
      case 'phone_iphone':
        return 'assets/images/products/phone.png';
      case 'laptop':
        return 'assets/images/products/laptop.png';
      case 'mouse':
        return 'assets/images/products/mouse.png';
      case 'keyboard':
        return 'assets/images/products/keyboard.png';
      case 'camera':
      case 'camera_alt':
      case 'videocam':
        return 'assets/images/products/camera.png';
      case 'battery':
      case 'usb':
      case 'devices':
      case 'sports_esports':
      default:
        return 'assets/images/products/default.png';
    }
  }
}
