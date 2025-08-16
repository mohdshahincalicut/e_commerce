import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce/providers/cart_provider.dart';
import 'package:e_commerce/screens/razer_pay_section_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  // Design constants
  static const double _appBarElevation = 0.0;
  static const double _starSize = 20.0;
  static const double _iconSize = 24.0;
  static const double _buttonBorderRadius = 8.0;
  static const double _cardBorderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    final productColor = _getProductColor(widget.product['color'] ?? 'blue');
    final productId = widget.product['id'] ?? 'unknown';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            _buildProductInfo(widget.product, productColor, productId),
            SizedBox(height: 24.h),
            _buildDescriptionSection(),
            SizedBox(height: 24.h),
            _buildSpecificationsSection(),
            SizedBox(height: 24.h),
            _buildReviewsSection(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: _appBarElevation,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
        onPressed: () => Navigator.pop(context),
      ),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: Icon(Icons.favorite_border, color: Colors.grey[800]),
        onPressed: () {
          _showSnackBar('Added to wishlist!');
        },
      ),
      IconButton(
        icon: Icon(Icons.share, color: Colors.grey[800]),
        onPressed: () {
          _showSnackBar('Sharing product...');
        },
      ),
    ];
  }

  Widget _buildImageSection() {
    final images = widget.product['images'] as List<dynamic>?;
    
    if (images != null && images.isNotEmpty) {
      return Container(
        height: 300.h,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _selectedImageIndex = index;
                  });
                },
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_cardBorderRadius.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_cardBorderRadius.r),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildFallbackImage();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  width: 8.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedImageIndex == index
                        ? Colors.deepPurple[800]
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 300.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_cardBorderRadius.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: _buildFallbackImage(),
      );
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(_cardBorderRadius.r),
      ),
      child: Icon(
        _getProductIcon(widget.product['icon'] ?? 'default'),
        size: 80.sp,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildProductInfo(Map<String, dynamic> product, Color productColor, String productId) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductName(product),
          SizedBox(height: 8.h),
          _buildRatingSection(product),
          SizedBox(height: 16.h),
          _buildPriceSection(product),
          SizedBox(height: 16.h),
          _buildQuantitySelector(),
          SizedBox(height: 24.h),
          _buildAddToCartSection(product, productColor, productId),
        ],
      ),
    );
  }

  Widget _buildProductName(Map<String, dynamic> product) {
    return Text(
      product['name'] as String? ?? 'Product Name',
      style: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildRatingSection(Map<String, dynamic> product) {
    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            final rating = product['rating'] as double? ?? 4.2;
            if (index < rating.floor()) {
              return Icon(
                Icons.star,
                color: Colors.amber,
                size: _starSize.sp,
              );
            } else if (index == rating.floor() && rating % 1 > 0) {
              return Icon(
                Icons.star_half,
                color: Colors.amber,
                size: _starSize.sp,
              );
            } else {
              return Icon(
                Icons.star_border,
                color: Colors.amber,
                size: _starSize.sp,
              );
            }
          }),
        ),
        SizedBox(width: 8.w),
        Text(
          '${product['rating'] as double? ?? 4.2} (${product['reviews'] as int? ?? 128} reviews)',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection(Map<String, dynamic> product) {
    final productPrice = (product['price'] as num?)?.toDouble() ?? 0.0;
    final originalPrice = (product['originalPrice'] as num?)?.toDouble() ?? 0.0;
    final totalPrice = productPrice * _quantity;
    final totalOriginalPrice = originalPrice * _quantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'AED ${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
            ),
            if (originalPrice > productPrice) ...[
              SizedBox(width: 12.w),
              Text(
                'AED ${totalOriginalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.sp,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '${((originalPrice - productPrice) / originalPrice * 100).round()}% OFF',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ),
            ],
          ],
        ),
        if (originalPrice > productPrice)
          Text(
            'You save AED ${(totalOriginalPrice - totalPrice).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.green[700],
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Quantity:',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(width: 16.w),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(_buttonBorderRadius.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_quantity > 1) {
                    setState(() {
                      _quantity--;
                    });
                  }
                },
                icon: Icon(
                  Icons.remove,
                  size: _iconSize.sp,
                  color: _quantity > 1 ? Colors.grey[800] : Colors.grey[400],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  '$_quantity',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
                icon: Icon(
                  Icons.add,
                  size: _iconSize.sp,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartSection(Map<String, dynamic> product, Color productColor, String productId) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isInCart(productId);
        final cartQuantity = cartProvider.getItemQuantity(productId);
        
        return Column(
          children: [
            if (isInCart)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(_buttonBorderRadius.r),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'In Cart: $cartQuantity items',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showCartDialog(context, cartProvider),
                      child: Text('View Cart'),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _addToCart(product, productColor, productId, cartProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[800],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_buttonBorderRadius.r),
                      ),
                    ),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _navigateToRazerPaySection(product, productId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_buttonBorderRadius.r),
                      ),
                    ),
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            widget.product['description'] as String? ?? 'No description available.',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsSection() {
    final specs = widget.product['specifications'] as Map<String, dynamic>?;
    if (specs == null || specs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Specifications',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12.h),
          ...specs.entries.map((entry) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100.w,
                  child: Text(
                    '${entry.key}:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value.toString(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  final rating = widget.product['rating'] as double? ?? 4.2;
                  if (index < rating.floor()) {
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: _starSize.sp,
                    );
                  } else if (index == rating.floor() && rating % 1 > 0) {
                    return Icon(
                      Icons.star_half,
                      color: Colors.amber,
                      size: _starSize.sp,
                    );
                  } else {
                    return Icon(
                      Icons.star_border,
                      color: Colors.amber,
                      size: _starSize.sp,
                    );
                  }
                }),
              ),
              SizedBox(width: 8.w),
              Text(
                '${widget.product['rating'] as double? ?? 4.2} out of 5',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '${widget.product['reviews'] as int? ?? 128} customer reviews',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product, Color productColor, String productId, CartProvider cartProvider) {
    for (int i = 0; i < _quantity; i++) {
      cartProvider.addItem(
        productId,
        product['name'] as String? ?? 'Product',
        (product['price'] as num?)?.toDouble() ?? 0.0,
        _getProductImage(product['icon'] ?? 'default'),
        productColor,
      );
    }
    _showSnackBar('${_quantity}x ${product['name']} added to cart!');
  }

  void _navigateToRazerPaySection(Map<String, dynamic> product, String productId) {
    final productPrice = (product['price'] as num?)?.toDouble() ?? 0.0;
    final totalAmount = productPrice * _quantity;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RazerPaySectionScreen(
          product: product,
          quantity: _quantity,
          totalAmount: totalAmount,
        ),
      ),
    );
  }

  void _showCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cart'),
        content: Text('View your cart items'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Color _getProductColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      default:
        return Colors.blue;
    }
  }

  String _getProductImage(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'phone':
        return 'assets/images/products/phone.png';
      case 'laptop':
        return 'assets/images/products/laptop.png';
      case 'headphones':
        return 'assets/images/products/headphones.png';
      case 'watch':
        return 'assets/images/products/watch.png';
      case 'camera':
        return 'assets/images/products/camera.png';
      case 'keyboard':
        return 'assets/images/products/keyboard.png';
      case 'mouse':
        return 'assets/images/products/mouse.png';
      case 'speaker':
        return 'assets/images/products/speaker.png';
      default:
        return 'assets/images/products/default.png';
    }
  }

  IconData _getProductIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'phone':
        return Icons.phone_android;
      case 'laptop':
        return Icons.laptop;
      case 'headphones':
        return Icons.headphones;
      case 'watch':
        return Icons.watch;
      case 'camera':
        return Icons.camera_alt;
      case 'keyboard':
        return Icons.keyboard;
      case 'mouse':
        return Icons.mouse;
      case 'speaker':
        return Icons.speaker;
      default:
        return Icons.devices;
    }
  }
}
