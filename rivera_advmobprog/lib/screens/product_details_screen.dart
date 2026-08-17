import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/products_model.dart';
import '../widgets/custom_text.dart';

// Added a product details screen to display
// detailed information about the selected product.
class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Product Details',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(
                  product.thumbnail,
                  width: double.infinity,
                  height: 280.h,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Container(
                    height: 280.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image,
                      size: 60.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Product Title
              CustomText(
                text: product.title,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: 8.h),

              // Brand and Category
              CustomText(
                text: '${product.brand} • ${product.category}',
                fontSize: 14.sp,
              ),

              SizedBox(height: 12.h),

              // Price
              CustomText(
                text: '\$${product.price.toStringAsFixed(2)}',
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: 12.h),

              // Rating
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 22.sp,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 6.w),
                  CustomText(
                    text: '${product.rating}',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Description
              CustomText(
                text: 'Description',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: 8.h),

              CustomText(
                text: product.description,
                fontSize: 14.sp,
              ),

              SizedBox(height: 20.h),

              // Product Information
              CustomText(
                text: 'Product Information',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: 8.h),

              _buildInfoRow(
                'Stock',
                '${product.stock}',
              ),

              _buildInfoRow(
                'Availability',
                product.availabilityStatus,
              ),

              _buildInfoRow(
                'Discount',
                '${product.discountPercentage.toStringAsFixed(2)}%',
              ),

              _buildInfoRow(
                'Brand',
                product.brand,
              ),

              _buildInfoRow(
                'SKU',
                product.sku,
              ),

              _buildInfoRow(
                'Warranty',
                product.warrantyInformation,
              ),

              _buildInfoRow(
                'Shipping',
                product.shippingInformation,
              ),

              _buildInfoRow(
                'Return Policy',
                product.returnPolicy,
              ),

              _buildInfoRow(
                'Minimum Order',
                '${product.minimumOrderQuantity}',
              ),

              SizedBox(height: 20.h),

              if (product.images.isNotEmpty) ...[
                CustomText(
                  text: 'More Images',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),

                SizedBox(height: 10.h),

                SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: product.images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(10.r),
                          child: Image.network(
                            product.images[index],
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              width: 100.w,
                              height: 100.h,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image,
                                size: 30.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: CustomText(
              text: label,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: CustomText(
              text: value,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}