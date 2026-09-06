import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/products_model.dart';
import '../services/product_services.dart';
import 'product_details_screen.dart';

const Color nuBlue = Color(0xFF293B91);
const Color nuDarkBlue = Color(0xFF17245F);
const Color nuGold = Color(0xFFFFD21F);
const Color background = Color(0xFFF7F8FC);

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<Product>> _productsFuture;

  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _productsFuture = ProductService().getAllProducts();

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (!mounted) return;

    setState(() {
      _searchQuery =
          _searchController.text.trim().toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _reloadProducts() {
    setState(() {
      _productsFuture = ProductService().getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          16.w,
          16.h,
          16.w,
          30.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            SizedBox(height: 18.h),
            _buildSearchBar(),
            SizedBox(height: 24.h),
            _buildSectionHeader(),
            SizedBox(height: 13.h),
            _buildProducts(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            nuBlue,
            nuDarkBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: nuBlue.withValues(alpha: 0.20),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62.w,
            height: 62.w,
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17.r),
            ),
            child: Image.asset(
              'assets/images/nubdexchange_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Icon(
                  Icons.storefront,
                  color: nuBlue,
                  size: 30.sp,
                );
              },
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Bulldogs!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Find something you will love today.',
                  style: TextStyle(
                    color:
                        Colors.white.withValues(alpha: 0.78),
                    fontSize: 11.5.sp,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 11.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: nuGold,
                    borderRadius:
                        BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'SHOP NOW',
                    style: TextStyle(
                      color: nuDarkBlue,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search products',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: nuBlue,
            size: 22.sp,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: _searchController.clear,
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey.shade500,
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: nuBlue.withValues(alpha: 0.25),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    final bool searching = _searchQuery.isNotEmpty;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              searching
                  ? 'Search Results'
                  : 'Featured Products',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF242424),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              searching
                  ? 'Products matching your search'
                  : 'Explore our latest collection',
              style: TextStyle(
                fontSize: 10.5.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        if (!searching)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: nuGold.withValues(alpha: 0.18),
              borderRadius:
                  BorderRadius.circular(20.r),
            ),
            child: Text(
              'NEW',
              style: TextStyle(
                color: nuDarkBlue,
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProducts() {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return Padding(
            padding:
                EdgeInsets.symmetric(vertical: 70.h),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 30.w,
                    height: 30.w,
                    child:
                        const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: nuBlue,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Loading products...',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return _buildError(
            snapshot.error.toString(),
          );
        }

        final List<Product> products =
            snapshot.data ?? <Product>[];

        final List<Product> filteredProducts =
            products.where((product) {
          return product.title
              .toLowerCase()
              .contains(_searchQuery);
        }).toList();

        if (filteredProducts.isEmpty) {
          return _buildEmpty();
        }

        return GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: filteredProducts.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: 0.67,
          ),
          itemBuilder: (context, index) {
            final Product product =
                filteredProducts[index];

            return _ProductCard(
              product: product,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProductDetailsScreen(
                      product: product,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildError(String error) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 45.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 10.h),
          Text(
            'Unable to load products',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            error,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 15.h),
          ElevatedButton(
            onPressed: _reloadProducts,
            style: ElevatedButton.styleFrom(
              backgroundColor: nuBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12.r),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(vertical: 55.h),
      child: Column(
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color:
                  nuBlue.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 32.sp,
              color: nuBlue,
            ),
          ),
          SizedBox(height: 13.h),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF303030),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'Try searching for another product.',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(18.r),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18.r),
            border: Border.all(
              color: Colors.grey.shade100,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withValues(alpha: 0.055),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFF7F7FA),
                    borderRadius:
                        BorderRadius.circular(14.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(9.w),
                    child: Image.network(
                      product.thumbnail,
                      fit: BoxFit.contain,
                      loadingBuilder:
                          (
                        context,
                        child,
                        loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return Center(
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: nuBlue,
                            value:
                                loadingProgress
                                            .expectedTotalBytes !=
                                        null
                                    ? loadingProgress
                                            .cumulativeBytesLoaded /
                                        loadingProgress
                                            .expectedTotalBytes!
                                    : null,
                          ),
                        );
                      },
                      errorBuilder:
                          (context, error, stackTrace) {
                        return Icon(
                          Icons.image_outlined,
                          size: 42.sp,
                          color: Colors.grey.shade400,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  11.w,
                  1.h,
                  11.w,
                  11.h,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        color:
                            const Color(0xFF292929),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight:
                                  FontWeight.w800,
                              color: nuBlue,
                            ),
                          ),
                        ),
                        Container(
                          width: 29.w,
                          height: 29.w,
                          decoration:
                              const BoxDecoration(
                            color: nuBlue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons
                                .arrow_forward_rounded,
                            color: Colors.white,
                            size: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
