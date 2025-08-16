import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../providers/cart_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/auth_provider.dart';
import '../../screens/product_detail_screen.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatabaseProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, databaseProvider, child) {
        if (databaseProvider.isLoadingProducts) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16.h),
             _buildShimmerGrid(),
            ],
          );
        }

        if (databaseProvider.productsError != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.sp,
                      color: Colors.red[300],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Failed to load products',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ElevatedButton(
                      onPressed: () {
                        databaseProvider.loadProducts();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        final products = databaseProvider.filteredProducts;
        
        if (products.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 48.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'No products available',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured Products',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            
            SizedBox(height: 16.h),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _ProductCard(product: products[index]);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: 6, // Show 6 shimmer cards
      itemBuilder: (context, index) {
        return _buildShimmerCard();
      },
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer for image area
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: Stack(
                  children: [
                    // Shimmer for main image
                    Center(
                      child: Container(
                        width: 60.sp,
                        height: 60.sp,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    // Shimmer for discount badge
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        width: 30.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                    // Shimmer for favorite button
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Shimmer for product info
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shimmer for product name
                    Container(
                      width: double.infinity,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Shimmer for rating
                    Row(
                      children: List.generate(5, (index) => 
                        Container(
                          width: 8.w,
                          height: 8.h,
                          margin: EdgeInsets.only(right: 2.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Shimmer for price
                    Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Container(
                          width: 30.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Shimmer for add to cart button
                    Container(
                      width: double.infinity,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final productId = product['id'] as String? ?? 'product_${DateTime.now().millisecondsSinceEpoch}';
    final productName = product['name'] as String? ?? 'Product';
    final productPrice = (product['price'] as num?)?.toDouble() ?? 0.0;
    final originalPrice = (product['originalPrice'] as num?)?.toDouble() ?? 0.0;
    
    // Calculate discount from discount string or price difference
    int discount = 0;
    if (product['discount'] is String) {
      final discountStr = product['discount'] as String;
      discount = int.tryParse(discountStr.replaceAll('%', '')) ?? 0;
    } else if (originalPrice > 0 && productPrice > 0) {
      discount = ((originalPrice - productPrice) / originalPrice * 100).round();
    }
    
    final rating = (product['rating'] as num?)?.toDouble() ?? 0.0;
    final reviews = (product['reviews'] as num?)?.toInt() ?? 0;
    final productColor = _getProductColor(product['color'] ?? 'blue');
    
    // Use first image from images array if available, otherwise fall back to icon
    String imageUrl;
    if (product['images'] is List && (product['images'] as List).isNotEmpty) {
      imageUrl = product['images'][0] as String;
    } else {
      imageUrl = _getProductImage(product['icon'] ?? 'default');
    }

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isInCart(productId);
        final quantity = cartProvider.getItemQuantity(productId);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },
          child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: imageUrl.startsWith('http')
                              ? Image.network(
                                  imageUrl,
                                  
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.shopping_bag,
                                      size: 45.sp,
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
                                  width: 45.sp,
                                  height: 45.sp,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.shopping_bag,
                                      size: 45.sp,
                                      color: productColor,
                                    );
                                  },
                                ),
                        ),
                        // Discount Badge
                        Positioned(
                          top: 4.h,
                          left: 4.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              '$discount%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Favorite Button
                        Positioned(
                          top: 4.h,
                          right: 4.w,
                          child: Consumer<DatabaseProvider>(
                            builder: (context, databaseProvider, child) {
                              final isInWishlist = databaseProvider.isInWishlist(productId);
                              return GestureDetector(
                                onTap: () async {
                                  final userId = context.read<AuthProvider>().currentUser?['user_id'];
                                  if (userId != null) {
                                    if (isInWishlist) {
                                      await databaseProvider.removeFromWishlist(userId, productId);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Removed from wishlist!')),
                                      );
                                    } else {
                                      await databaseProvider.addToWishlist(userId, productId);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Added to wishlist!')),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isInWishlist ? Icons.favorite : Icons.favorite_border,
                                    size: 12.sp,
                                    color: isInWishlist ? Colors.red : Colors.grey[600],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Product Info
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(6.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Flexible(
                          child: Text(
                            productName,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        SizedBox(height: 2.h),
                        
                        // Rating Row
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (starIndex) {
                                if (starIndex < rating.floor()) {
                                  return Icon(
                                    Icons.star,
                                    size: 10.sp,
                                    color: Colors.amber,
                                  );
                                } else if (starIndex == rating.floor() && rating % 1 > 0) {
                                  return Icon(
                                    Icons.star_half,
                                    size: 10.sp,
                                    color: Colors.amber,
                                  );
                                } else {
                                  return Icon(
                                    Icons.star_border,
                                    size: 10.sp,
                                    color: Colors.amber,
                                  );
                                }
                              }),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '($reviews)',
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 2.h),
                        
                        // Price Row
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'AED ${productPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[800],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Flexible(
                              child: Text(
                                'AED ${originalPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.lineThrough,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 4.h),
                        
                        // Cart Button or Quantity Controls
                        if (!isInCart)
                          GestureDetector(
                            onTap: () {
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
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[800],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    cartProvider.removeItem(productId);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      size: 12.sp,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    '$quantity',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple[800],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    cartProvider.addItem(
                                      productId,
                                      productName,
                                      productPrice,
                                      imageUrl,
                                      productColor,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 12.sp,
                                      color: Colors.green[700],
                                    ),
                                  ),
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
          ),
        );
      },
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
