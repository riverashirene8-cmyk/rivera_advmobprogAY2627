import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/products_model.dart';

class ProductService {
  // ==========================================================
  // Get all products
  // ==========================================================

  Future<List<Product>> getAllProducts() async {
    final response = await http.get(
      Uri.parse('$host/products'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load products. '
        'Status: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body);

    final List productsJson =
        data['products'] ?? [];

    return productsJson
        .map(
          (json) => Product.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  // ==========================================================
  // Get one product by ID
  // ==========================================================

  Future<Product> getProductById(int id) async {
    final response = await http.get(
      Uri.parse('$host/products/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load product. '
        'Status: ${response.statusCode}',
      );
    }

    return Product.fromJson(
      Map<String, dynamic>.from(
        jsonDecode(response.body),
      ),
    );
  }
}