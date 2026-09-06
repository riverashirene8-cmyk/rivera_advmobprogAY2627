import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/products_model.dart';
import '../services/cart_service.dart';
import '../services/user_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  final UserService _userService = UserService();

  List<CartProduct> _items = [];

  bool _isLoading = false;

  String? _error;

  int? _userId;

  List<CartProduct> get items => _items;

  bool get isLoading => _isLoading;

  String? get error => _error;

  int? get userId => _userId;

  // ENHANCEMENT 3:
  // Gets the ID of the currently authenticated user
  // from the saved user data through UserService.
  // This prevents the cart from using a hardcoded user ID.
  Future<int> _getCurrentUserId() async {
    if (_userId != null) {
      return _userId!;
    }

    final user = await _userService.getUser();

    _userId = user.id;

    return user.id;
  }

  // ENHANCEMENT 3:
  // Loads the cart belonging to the currently
  // authenticated user using the saved user ID.
  Future<void> loadCart() async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      final userId = await _getCurrentUserId();

      final cart =
          await _cartService.getCartByUserId(userId);

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
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  // ENHANCEMENT 3:
  // Adds the selected product to the cart using
  // the currently authenticated user's ID.
  Future<void> addProduct(
    Product product,
  ) async {
    _error = null;

    try {
      final userId = await _getCurrentUserId();

      final addedCart =
          await _cartService.addToCart(
        userId: userId,
        productId: product.id,
        quantity: 1,
      );

      final index = _items.indexWhere(
        (item) => item.id == product.id,
      );

      if (index >= 0) {
        _items[index] =
            _items[index].copyWith(
          quantity:
              _items[index].quantity + 1,
        );
      } else {
        CartProduct addedItem;

        try {
          addedItem =
              addedCart.products.firstWhere(
            (item) => item.id == product.id,
          );
        } catch (_) {
          addedItem = CartProduct(
            id: product.id,
            title: product.title,
            price: product.price,
            quantity: 1,
            total: product.price,
            discountPercentage:
                product.discountPercentage,
            discountedTotal:
                product.price *
                    (1 -
                        product.discountPercentage /
                            100),
            thumbnail: product.thumbnail,
          );
        }

        _items.add(addedItem);
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();

      notifyListeners();

      rethrow;
    }
  }

  void increaseQuantity(
    int index,
  ) {
    if (index < 0 ||
        index >= _items.length) {
      return;
    }

    final item = _items[index];

    _items[index] =
        item.copyWith(
      quantity: item.quantity + 1,
    );

    notifyListeners();
  }

  void decreaseQuantity(
    int index,
  ) {
    if (index < 0 ||
        index >= _items.length) {
      return;
    }

    final item = _items[index];

    if (item.quantity > 1) {
      _items[index] =
          item.copyWith(
        quantity: item.quantity - 1,
      );
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  double get subtotal {
    return _items.fold(
      0.0,
      (sum, item) => sum + item.total,
    );
  }

  double get discount {
    return _items.fold(
      0.0,
      (sum, item) =>
          sum +
          (item.total -
              item.discountedTotal),
    );
  }

  double get total {
    return subtotal - discount;
  }

  int get totalQuantity {
    return _items.fold(
      0,
      (sum, item) =>
          sum + item.quantity,
    );
  }

  void clearCart() {
    _items.clear();

    notifyListeners();
  }
}