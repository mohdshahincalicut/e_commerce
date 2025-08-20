import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/database_provider.dart';
import '../../screens/search_results_screen.dart';
import '../../screens/network_error_screen.dart';
import '../../services/network_service.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;
  List<String> _searchSuggestions = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isExpanded = _focusNode.hasFocus;
    });
    
    if (_focusNode.hasFocus) {
      _updateSearchSuggestions();
    }
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _updateSearchSuggestions();
    } else {
      setState(() {
        _searchSuggestions.clear();
      });
    }
  }

  void _updateSearchSuggestions() {
    final databaseProvider = context.read<DatabaseProvider>();
    final query = _searchController.text.toLowerCase();
    
    if (query.isEmpty) {
      setState(() {
        _searchSuggestions.clear();
      });
      return;
    }

    // Generate suggestions based on product names
    final suggestions = <String>{};
    
    for (var product in databaseProvider.products) {
      final productName = product['name']?.toString().toLowerCase() ?? '';
      final description = product['description']?.toString().toLowerCase() ?? '';
      final categoryId = product['categoryId']?.toString().toLowerCase() ?? '';
      
      if (productName.contains(query)) {
        suggestions.add(product['name']?.toString() ?? '');
      }
      
      if (description.contains(query)) {
        suggestions.add(product['name']?.toString() ?? '');
      }
      
      if (categoryId.contains(query)) {
        suggestions.add(categoryId);
      }
      
      // Add partial matches
      final words = productName.split(' ');
      for (var word in words) {
        if (word.startsWith(query) && word.length > query.length) {
          suggestions.add(word);
        }
      }
    }
    
    setState(() {
      _searchSuggestions = suggestions.take(5).toList();
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    _focusNode.unfocus();
    
    // Check network connectivity before performing search
    final networkService = NetworkService();
    final hasConnection = await networkService.hasInternetConnection();
    
    if (!hasConnection) {
      // Navigate to network error screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NetworkErrorScreen(
            errorMessage: 'Unable to search products. Please check your internet connection.',
            onRetry: () {
              Navigator.pop(context);
              _performSearch(query);
            },
          ),
        ),
      );
      return;
    }
    
    // Navigate to search results screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(searchQuery: query.trim()),
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchSuggestions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12.h),
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
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Search products, categories...',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 16.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20.sp,
                color: Colors.grey[600],
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Clear button
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: _clearSearch,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        child: Icon(
                          Icons.clear,
                          size: 18.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  
                  // Voice search button
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement voice search functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voice search coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      margin: EdgeInsets.only(right: 8.w),
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
            ),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[800],
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _performSearch,
          ),
        ),
        
        // Search suggestions dropdown
        if (_isExpanded && _searchSuggestions.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: _searchSuggestions.map((suggestion) {
                return InkWell(
                  onTap: () {
                    _searchController.text = suggestion;
                    _performSearch(suggestion);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 16.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            suggestion,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Icon(
                          Icons.north_west,
                          size: 14.sp,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
