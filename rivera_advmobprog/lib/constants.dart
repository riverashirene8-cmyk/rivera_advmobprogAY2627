import 'package:flutter_dotenv/flutter_dotenv.dart';

// API host
final String host =
    dotenv.env['HOST'] ?? 'https://dummyjson.com';

// ==========================================================
// I use DummyJSON User ID 1 so the app displays one user's cart.
//
// The CartScreen will load only this user's cart through:
// GET /carts/user/1
// ==========================================================

const int dummyUserId = 1;