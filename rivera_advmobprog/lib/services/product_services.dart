import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/products_model.dart';

class ProductService {
  Future<List<Product>> getAllProducts() async {
    final String url = '$host/products';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load products. '
        'Status: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(
      jsonDecode(response.body),
    );

    final List<dynamic> products =
        data['products'] as List<dynamic>? ?? [];

    return products
        .map(
          (json) => Product.fromJson(
            Map<String, dynamic>.from(
              json as Map,
            ),
          ),
        )
        .toList();
  }

  Future<Product> getProductById(int id) async {
    final String url = '$host/products/$id';

    final response = await http.get(
      Uri.parse(url),
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