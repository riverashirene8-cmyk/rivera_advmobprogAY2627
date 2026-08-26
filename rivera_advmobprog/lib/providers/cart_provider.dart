import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/cart.dart';
import '../models/products_model.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  List<CartProduct> _items = [];

  bool _isLoading = false;

  String? _error;

  // ==========================================================
  // Getters
  // ==========================================================

  List<CartProduct> get items => _items;

  bool get isLoading => _isLoading;

  String? get error => _error;

  // ==========================================================
  // This loads the cart for DummyJSON User ID 1 from the API.
  //
  // This calls:
  // GET /carts/user/1
  // ==========================================================

  Future<void> loadCart() async {
    _isLoading = true;

    _error = null;

    notifyListeners();

    try {
      final cart =
          await _cartService.getCartByUserId(
        dummyUserId,
      );

      if (cart != null) {
        final currentItemsById = {
          for (final item in _items) item.id: item,
        };

        final loadedItems = cart.products.map(
          (item) => currentItemsById[item.id] ?? item,
        );

        final serverItemIds = cart.products
            .map((item) => item.id)
            .toSet();

        _items = [
          ...loadedItems,
          ..._items.where(
            (item) => !serverItemIds.contains(item.id),
          ),
        ];
      } else {
        _items = List<CartProduct>.from(_items);
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  // ==========================================================
  // This sends the product to DummyJSON and then updates the local cart.
  //
  // The API call is made first.
  // Since DummyJSON does not permanently save POST changes,
  // we also update the local cart after a successful request.
  // ==========================================================

  Future<void> addProduct(Product product) async {
    _error = null;

    try {
      final addedCart = await _cartService.addToCart(
        userId: dummyUserId,
        productId: product.id,
        quantity: 1,
      );

      final index = _items.indexWhere(
        (item) => item.id == product.id,
      );

      if (index >= 0) {
        _items[index] = _items[index].copyWith(
          quantity: _items[index].quantity + 1,
        );
      } else {
        final addedItem = addedCart.products.firstWhere(
          (item) => item.id == product.id,
          orElse: () => CartProduct(
            id: product.id,
            title: product.title,
            price: product.price,
            quantity: 1,
            total: product.price,
            discountPercentage: product.discountPercentage,
            discountedTotal: product.price *
                (1 - product.discountPercentage / 100),
            thumbnail: product.thumbnail,
          ),
        );

        _items.add(addedItem);
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();

      notifyListeners();

      rethrow;
    }
  }

  // ==========================================================
  // Increase quantity
  // ==========================================================

  void increaseQuantity(int index) {
    if (index < 0 || index >= _items.length) {
      return;
    }

    final item = _items[index];

    _items[index] = item.copyWith(
      quantity: item.quantity + 1,
    );

    notifyListeners();
  }

  // ==========================================================
  // Decrease quantity
  // ==========================================================

  void decreaseQuantity(int index) {
    if (index < 0 || index >= _items.length) {
      return;
    }

    final item = _items[index];

    if (item.quantity > 1) {
      _items[index] = item.copyWith(
        quantity: item.quantity - 1,
      );
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  // ==========================================================
  // Subtotal
  // ==========================================================

  double get subtotal {
    return _items.fold(
      0.0,
      (sum, item) => sum + item.total,
    );
  }

  // ==========================================================
  // Total discount
  // ==========================================================

  double get discount {
    return _items.fold(
      0.0,
      (sum, item) =>
          sum +
          (item.total - item.discountedTotal),
    );
  }

  // ==========================================================
  // Final total
  // ==========================================================

  double get total {
    return subtotal - discount;
  }

  // ==========================================================
  // Total quantity
  // ==========================================================

  int get totalQuantity {
    return _items.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  // ==========================================================
  // Clear cart
  // ==========================================================

  void clearCart() {
    _items.clear();

    notifyListeners();
  }
}