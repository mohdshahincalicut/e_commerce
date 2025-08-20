import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async'; // Added for Timer

class MegaDealBanner extends StatefulWidget {
  const MegaDealBanner({super.key});

  @override
  State<MegaDealBanner> createState() => _MegaDealBannerState();
}

class _MegaDealBannerState extends State<MegaDealBanner> {
  late PageController _pageController;
  List<Map<String, dynamic>> _ads = [];
  bool _isLoading = true;
  int _currentPage = 0;
  Timer? _autoScrollTimer; // Added for auto-scroll timer

  @override
  void initState() {
    super.initState();
    _loadAdsFromFirestore();
  }

  void _initializePageController() {
    if (_ads.isNotEmpty) {
      // Initialize PageController to start from middle for infinite scroll
      final initialPage = (_ads.length * 1000 ~/ 2);
      _pageController = PageController(initialPage: initialPage);
      _currentPage = 0; // Reset current page to 0 for indicators
    }
  }

  @override
  void dispose() {
    if (_ads.isNotEmpty) {
      _pageController.dispose();
    }
    _autoScrollTimer?.cancel(); // Cancel timer on dispose
    super.dispose();
  }

  Future<void> _loadAdsFromFirestore() async {
    try {
      final QuerySnapshot adsSnapshot = await FirebaseFirestore.instance
          .collection('adds')
          .get();

      if (adsSnapshot.docs.isNotEmpty) {
        final List<Map<String, dynamic>> ads = [];
        
        for (var doc in adsSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          // Extract image URLs from the document
          final List<String> imageUrls = [];
          
          // Check for image fields (new, new1, new2, new3, new5)
          for (int i = 0; i <= 5; i++) {
            final fieldName = i == 0 ? 'new' : 'new$i';
            if (data.containsKey(fieldName) && data[fieldName] != null) {
              final imageUrl = data[fieldName] as String;
              if (imageUrl.isNotEmpty) {
                imageUrls.add(imageUrl);
              }
            }
          }
          
          // Add each image URL as a separate ad
          for (String imageUrl in imageUrls) {
            ads.add({
              'id': '${doc.id}_${ads.length}',
              'imageUrl': imageUrl,
              'title': 'Special Offer',
            });
          }
        }
        
        if (mounted) {
          setState(() {
            _ads = ads;
            _isLoading = false;
          });
          
          // Initialize PageController and start auto-scroll after loading ads
          if (ads.isNotEmpty) {
            _initializePageController();
            _startAutoScroll();
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading ads: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startAutoScroll() {
    if (_ads.length <= 1) return;
    
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && _ads.isNotEmpty) {
        // Always move to next page, PageView will handle the infinite loop
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        height: 200.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 204, 203, 203)!,
              const Color.fromARGB(255, 154, 154, 154)!,
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    if (_ads.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 204, 203, 203)!,
              const Color.fromARGB(255, 154, 154, 154)!,
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MEGA DEAL',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No ads available at the moment',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // PageView for scrolling ads with infinite loop
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index % _ads.length;
                });
              },
              itemCount: _ads.length * 1000, // Large number for infinite scroll
              itemBuilder: (context, index) {
                final actualIndex = index % _ads.length;
                final ad = _ads[actualIndex];
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                       
              const Color.fromARGB(255, 204, 203, 203)!,
              const Color.fromARGB(255, 154, 154, 154)!,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background Image with error handling
                      if (ad['imageUrl'] != null)
                        Positioned.fill(
                          child: Container(
                            color: Colors.grey[100],
                            child: _buildNetworkImage(ad['imageUrl']),
                          ),
                        ),
                      
                      // Overlay for better text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                      
                      // Content
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MEGA DEAL',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              ad['title'] ?? 'Special Offer',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                'Shop Now',
                                style: TextStyle(
                                  color: Colors.orange[600],
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            // Page indicators
            if (_ads.length > 1)
              Positioned(
                bottom: 16.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _ads.length,
                    (index) => Container(
                      width: 8.w,
                      height: 8.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkImage(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.fill, // Changed to fill to stretch image to container
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Error loading image: $error');
        return Container(
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 50.sp,
                color: Colors.grey[600],
              ),
              SizedBox(height: 8.h),
              Text(
                'Image not available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: Colors.orange[600],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      // Add timeout and retry options
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
    );
  }
}
