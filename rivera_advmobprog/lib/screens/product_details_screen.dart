import 'package:flutter/material.dart';

import '../models/products_model.dart';

import 'detail_screen.dart';

class ProductDetailsScreen
    extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    // I use the detail screen here to show the selected product information.
    return DetailScreen(
      productId: product.id,
    );
  }
}