import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/cart.dart';

class CartService {
  Future<Cart?> getCartByUserId(int userId) async {
    final Uri url = Uri.parse('$host/carts/user/$userId');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load cart. Status: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(jsonDecode(response.body));

    final List<dynamic> carts =
        data['carts'] as List<dynamic>? ?? [];

    if (carts.isEmpty) {
      return null;
    }

    return Cart.fromJson(
      Map<String, dynamic>.from(carts.first as Map),
    );
  }

  Future<Cart> addToCart({
    required int userId,
    required int productId,
    required int quantity,
  }) async {
    final Uri url = Uri.parse('$host/carts/add');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'products': [
          {
            'id': productId,
            'quantity': quantity,
          },
        ],
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(
        'Failed to add product to cart. '
        'Status: ${response.statusCode}',
      );
    }

    return Cart.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body)),
    );
  }
}
