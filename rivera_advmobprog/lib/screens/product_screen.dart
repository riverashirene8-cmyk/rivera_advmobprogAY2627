import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/products_model.dart';
import '../services/product_services.dart';
import '../widgets/custom_text.dart';

import 'product_details_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() =>
      _ProductScreenState();
}

class _ProductScreenState
    extends State<ProductScreen> {
  late Future<List<Product>> _productsFuture;

  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _productsFuture =
        ProductService().getAllProducts();

    _searchController.addListener(() {
      setState(() {
        _searchQuery =
            _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon:
                    const Icon(Icons.search),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                          ),
                          onPressed: () {
                            _searchController
                                .clear();
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12.r),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Padding(
                    padding:
                        EdgeInsets.all(30.r),
                    child:
                        const CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return CustomText(
                    text:
                        'Error: ${snapshot.error}',
                    fontSize: 14.sp,
                  );
                }

                final products =
                    snapshot.data ?? [];

                final filteredProducts =
                    products.where((product) {
                  return product.title
                      .toLowerCase()
                      .contains(_searchQuery);
                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Text(
                    'No products found.',
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount:
                      filteredProducts.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder:
                      (context, index) {
                    final product =
                        filteredProducts[index];

                    return Card(
                      elevation: 2,
                      clipBehavior:
                          Clip.antiAlias,
                      child: InkWell(
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
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                product.thumbnail,
                                width:
                                    double.infinity,
                                fit: BoxFit.contain,
                                errorBuilder:
                                  (context, error, stackTrace) =>
                                        const Icon(
                                  Icons.image,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.all(8.r),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  CustomText(
                                    text:
                                        product.title,
                                    fontSize: 14.sp,
                                    fontWeight:
                                        FontWeight.bold,
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  CustomText(
                                    text:
                                        '\$${product.price.toStringAsFixed(2)}',
                                    fontSize: 13.sp,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}