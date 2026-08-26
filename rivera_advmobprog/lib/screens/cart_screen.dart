import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'detail_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    // ==========================================================
    // I load the cart for DummyJSON User ID 1 when this screen opens.
    // ==========================================================

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      context.read<CartProvider>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (cartProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (cartProvider.error != null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Text(
                cartProvider.error!,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final items = cartProvider.items;

        if (items.isEmpty) {
          return const Center(
            child: Text(
              'Your cart is empty.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          );
        }

        return SafeArea(
          child: Column(
            children: [
              // ==================================================
              // CART ITEMS
              // ==================================================

              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    10.w,
                    12.h,
                    10.w,
                    5.h,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Container(
                      margin: EdgeInsets.only(
                        bottom: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface,
                        borderRadius:
                            BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.05,
                            ),
                            blurRadius: 8,
                            offset:
                                const Offset(0, 3),
                          ),
                        ],
                      ),

                      // ==================================================
                      // Tapping a cart item opens its product details.
                      // ==================================================

                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(12.r),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailScreen(
                                productId: item.id,
                              ),
                            ),
                          );
                        },

                        child: Padding(
                          padding:
                              EdgeInsets.all(10.r),

                          child: Row(
                            children: [
                              // ==================================================
                              // PRODUCT IMAGE
                              // ==================================================

                              Container(
                                width: 75.w,
                                height: 75.h,
                                decoration:
                                    BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius
                                          .circular(8.r),
                                ),
                                child: Image.network(
                                  item.thumbnail,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return const Icon(
                                      Icons
                                          .image_not_supported,
                                    );
                                  },
                                ),
                              ),

                              SizedBox(width: 10.w),

                              // ==================================================
                              // PRODUCT INFORMATION
                              // ==================================================

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      item.title,
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow
                                              .ellipsis,
                                      style:
                                          TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    SizedBox(
                                      height: 5.h,
                                    ),

                                    Text(
                                      '\$${item.price.toStringAsFixed(2)}',
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .amber
                                            .shade800,
                                        fontSize: 13.sp,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    SizedBox(
                                      height: 3.h,
                                    ),

                                    Text(
                                      '${item.discountPercentage.toStringAsFixed(0)}% off • \$${item.discountedTotal.toStringAsFixed(2)} total',
                                      style:
                                          TextStyle(
                                        fontSize: 9.sp,
                                        color: Colors
                                            .grey
                                            .shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 8.w),

                              // ==================================================
                              // QUANTITY BUTTONS
                              // ==================================================

                              Column(
                                children: [
                                  SizedBox(
                                    width: 32.w,
                                    height: 32.h,
                                    child:
                                        ElevatedButton(
                                      onPressed: () {
                                        cartProvider
                                            .increaseQuantity(
                                          index,
                                        );
                                      },
                                      style:
                                          ElevatedButton
                                              .styleFrom(
                                        padding:
                                            EdgeInsets
                                                .zero,
                                        backgroundColor:
                                            const Color(
                                          0xFFFFC107,
                                        ),
                                        foregroundColor:
                                            Colors.black,
                                        shape:
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            8.r,
                                          ),
                                        ),
                                      ),
                                      child:
                                          const Icon(
                                        Icons.add,
                                        size: 18,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 4.h,
                                  ),

                                  Text(
                                    '${item.quantity}',
                                    style:
                                        TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  SizedBox(
                                    height: 4.h,
                                  ),

                                  SizedBox(
                                    width: 32.w,
                                    height: 32.h,
                                    child:
                                        ElevatedButton(
                                      onPressed: () {
                                        cartProvider
                                            .decreaseQuantity(
                                          index,
                                        );
                                      },
                                      style:
                                          ElevatedButton
                                              .styleFrom(
                                        padding:
                                            EdgeInsets
                                                .zero,
                                        backgroundColor:
                                            Theme.of(
                                          context,
                                        )
                                                .colorScheme
                                                .surfaceContainerHighest,
                                        foregroundColor:
                                            Colors.grey
                                                .shade700,
                                        shape:
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            8.r,
                                          ),
                                        ),
                                      ),
                                      child:
                                          const Icon(
                                        Icons.remove,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ==================================================
              // ORDER SUMMARY
              // ==================================================

              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  8.h,
                  16.w,
                  10.h,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.05,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _summaryRow(
                      'Subtotal',
                      cartProvider.subtotal,
                    ),

                    SizedBox(height: 5.h),

                    _summaryRow(
                      'Discount',
                      cartProvider.discount,
                      isDiscount: true,
                    ),

                    SizedBox(height: 7.h),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${cartProvider.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight:
                                FontWeight.bold,
                            color: const Color(
                              0xFF3949AB,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    // ==================================================
                    // CONFIRM ORDER
                    // ==================================================

                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Order confirmed!',
                              ),
                            ),
                          );
                        },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFFFFC107,
                          ),
                          foregroundColor:
                              Colors.black,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              10.r,
                            ),
                          ),
                        ),
                        child: Text(
                          'Confirm Order',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                                FontWeight.bold,
                          ),
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
    );
  }

  Widget _summaryRow(
    String title,
    double value, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          '${isDiscount ? '-' : ''}\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 12.sp,
            color: isDiscount
                ? Colors.green
                : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}