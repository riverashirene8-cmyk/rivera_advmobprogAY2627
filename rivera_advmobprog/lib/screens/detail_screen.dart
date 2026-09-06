import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/products_model.dart';
import '../providers/cart_provider.dart';
import '../services/product_services.dart';

class DetailScreen extends StatefulWidget {
  final int productId;

  const DetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<DetailScreen> createState() =>
      _DetailScreenState();
}

class _DetailScreenState
    extends State<DetailScreen> {
  late final Future<Product>
      _productFuture;

  bool _isAdding = false;

  @override
  void initState() {
    super.initState();

    _productFuture =
        ProductService()
            .getProductById(
      widget.productId,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          'Product Details',
        ),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder:
            (context, snapshot) {
          if (snapshot
                  .connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Product not found.',
              ),
            );
          }

          final product =
              snapshot.data!;

          return SingleChildScrollView(
            padding:
                EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Image.network(
                  product.thumbnail,
                  width:
                      double.infinity,
                  height: 250.h,
                  fit:
                      BoxFit.contain,
                  errorBuilder:
                      (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return SizedBox(
                      height: 250.h,
                      child:
                          const Icon(
                        Icons
                            .image_not_supported,
                        size: 50,
                      ),
                    );
                  },
                ),

                SizedBox(
                  height: 20.h,
                ),

                Text(
                  product.title,
                  style:
                      TextStyle(
                    fontSize: 22.sp,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),

                SizedBox(
                  height: 10.h,
                ),

                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style:
                      TextStyle(
                    fontSize: 20.sp,
                    fontWeight:
                        FontWeight
                            .bold,
                    color:
                        const Color(
                      0xFF3949AB,
                    ),
                  ),
                ),

                SizedBox(
                  height: 15.h,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  height: 48.h,
                  child:
                      ElevatedButton
                          .icon(
                    onPressed:
                        _isAdding
                            ? null
                            : () =>
                                _addToCart(
                                  product,
                                ),
                    icon: _isAdding
                        ? SizedBox(
                            width: 18.w,
                            height: 18.h,
                            child:
                                const CircularProgressIndicator(
                              strokeWidth:
                                  2,
                            ),
                          )
                        : const Icon(
                            Icons
                                .add_shopping_cart,
                          ),
                    label: Text(
                      _isAdding
                          ? 'Adding...'
                          : 'Add to cart',
                    ),
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          const Color(
                        0xFFFFC107,
                      ),
                      foregroundColor:
                          Colors.black,
                    ),
                  ),
                ),

                SizedBox(
                  height: 20.h,
                ),

                Text(
                  product.description,
                  style:
                      TextStyle(
                    fontSize: 14.sp,
                  ),
                ),

                SizedBox(
                  height: 15.h,
                ),

                Text(
                  'Rating: ${product.rating}',
                  style:
                      TextStyle(
                    fontSize: 14.sp,
                  ),
                ),

                SizedBox(
                  height: 5.h,
                ),

                Text(
                  'Stock: ${product.stock}',
                  style:
                      TextStyle(
                    fontSize: 14.sp,
                  ),
                ),

                SizedBox(
                  height: 5.h,
                ),

                Text(
                  'Category: ${product.category}',
                  style:
                      TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _addToCart(
    Product product,
  ) async {
    setState(() {
      _isAdding = true;
    });

    try {
      await context
          .read<CartProvider>()
          .addProduct(product);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Product added to cart',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            'Could not add product: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }
}