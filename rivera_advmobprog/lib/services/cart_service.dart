import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/cart.dart';

class CartService {
  // ENHANCEMENT 3:
  // Loads the cart using the saved user's ID.
  // This allows the application to display the cart
  // belonging to the currently authenticated user.
  Future<Cart?> getCartByUserId(int userId) async {
    final String url = '$host/carts/user/$userId';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load cart. Status: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(
      jsonDecode(response.body),
    );

    final List<dynamic> carts =
        data['carts'] as List<dynamic>? ?? [];

    if (carts.isEmpty) {
      return null;
    }

    return Cart.fromJson(
      Map<String, dynamic>.from(
        carts.first as Map,
      ),
    );
  }

  // ENHANCEMENT 3:
  // Adds a product to the cart using the current
  // authenticated user's ID instead of a hardcoded ID.
  Future<Cart> addToCart({
    required int userId,
    required int productId,
    required int quantity,
  }) async {
    final String url = '$host/carts/add';

    final response = await http.post(
      Uri.parse(url),
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
      Map<String, dynamic>.from(
        jsonDecode(response.body),
      ),
    );
  }
}