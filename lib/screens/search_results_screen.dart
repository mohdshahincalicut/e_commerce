import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/database_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import 'product_detail_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = true;
  String _sortBy = 'relevance'; // relevance, price_low, price_high, rating

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _isLoading = true;
    });

    final databaseProvider = context.read<DatabaseProvider>();
    final query = widget.searchQuery.toLowerCase();
    
    final results = databaseProvider.products.where((product) {
      final name = product['name']?.toString().toLowerCase() ?? '';
      final description = product['description']?.toString().toLowerCase() ?? '';
      final categoryId = product['categoryId']?.toString().toLowerCase() ?? '';
      
      return name.contains(query) || 
             description.contains(query) || 
             categoryId.contains(query);
    }).toList();

    // Sort results
    _sortResults(results);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  void _sortResults(List<Map<String, dynamic>> results) {
    switch (_sortBy) {
      case 'price_low':
        results.sort((a, b) {
          final priceA = (a['price'] as num?)?.toDouble() ?? 0.0;
          final priceB = (b['price'] as num?)?.toDouble() ?? 0.0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_high':
        results.sort((a, b) {
          final priceA = (a['price'] as num?)?.toDouble() ?? 0.0;
          final priceB = (b['price'] as num?)?.toDouble() ?? 0.0;
          return priceB.compareTo(priceA);
        });
        break;
      case 'rating':
        results.sort((a, b) {
          final ratingA = (a['rating'] as num?)?.toDouble() ?? 0.0;
          final ratingB = (b['rating'] as num?)?.toDouble() ?? 0.0;
          return ratingB.compareTo(ratingA);
        });
        break;
      case 'relevance':
      default:
        // Keep original order for relevance
        break;
    }
  }

  void _changeSortOrder(String newSortBy) {
    setState(() {
      _sortBy = newSortBy;
    });
    _sortResults(_searchResults);
    setState(() {});
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16.h),
              _buildSortOption('Relevance', 'relevance'),
              _buildSortOption('Price: Low to High', 'price_low'),
              _buildSortOption('Price: High to Low', 'price_high'),
              _buildSortOption('Customer Rating', 'rating'),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title, String value) {
    final isSelected = _sortBy == value;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: isSelected ? Colors.deepPurple[800] : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check,
              color: Colors.deepPurple[800],
              size: 20.sp,
            )
          : null,
      onTap: () {
        Navigator.pop(context);
        _changeSortOrder(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        title: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 18.sp,
                color: Colors.grey[600],
              ),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[800],
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (query) {
              if (query.trim().isNotEmpty) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsScreen(
                      searchQuery: query.trim(),
                    ),
                  ),
                );
              }
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showSortOptions,
            icon: Icon(
              Icons.sort,
              color: Colors.grey[800],
              size: 24.sp,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search results header
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Results for "${widget.searchQuery}"',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                if (!_isLoading)
                  Text(
                    '${_searchResults.length} items',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          
          // Search results content
          Expanded(
            child: _buildSearchContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return _SearchResultCard(product: _searchResults[index]);
      },
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try searching with different keywords\nor check your spelling',
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
              'Back to Home',
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
}

class _SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const _SearchResultCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final productId = product['id'] as String? ?? 'product_${DateTime.now().millisecondsSinceEpoch}';
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

    return Consumer2<CartProvider, DatabaseProvider>(
      builder: (context, cartProvider, databaseProvider, child) {
        final isInCart = cartProvider.isInCart(productId);
        final quantity = cartProvider.getItemQuantity(productId);
        final isInWishlist = databaseProvider.isInWishlist(productId);

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
                        if (discount > 0)
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
                          child: GestureDetector(
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
                            if (originalPrice > productPrice) ...[
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
