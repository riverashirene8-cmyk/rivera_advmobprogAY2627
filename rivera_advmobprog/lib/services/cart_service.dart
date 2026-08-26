import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/cart.dart';

class CartService {
  // This gets the cart for one DummyJSON user.

  Future<Cart?> getCartByUserId(int userId) async {
    final response = await http.get(
      Uri.parse('$host/carts/user/$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load cart. '
        'Status: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body);

    final List cartsJson =
        data['carts'] ?? [];

    if (cartsJson.isEmpty) {
      return null;
    }

    // I use the first cart returned for this user.
    return Cart.fromJson(
      Map<String, dynamic>.from(
        cartsJson.first,
      ),
    );
  }

  // This sends the selected product to DummyJSON's add-cart endpoint.
  // The provider updates the local cart because the API does not save the change permanently.

  Future<Cart> addToCart({
    required int userId,
    required int productId,
    required int quantity,
  }) async {
    final response = await http.post(
      Uri.parse('$host/carts/add'),
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

    if (response.statusCode != 200 && response.statusCode != 201) {
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