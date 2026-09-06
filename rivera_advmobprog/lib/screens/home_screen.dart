import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/user_service.dart';
import 'cart_screen.dart';
import 'product_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageController _pageController =
      PageController(initialPage: 0);

  final UserService _userService = UserService();

  String _firstName = '';

  static const Color nuBlue = Color(0xFF293B91);
  static const Color nuDarkBlue = Color(0xFF17245F);
  static const Color nuGold = Color(0xFFFFD21F);

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = await _userService.getUser();

    if (!mounted) return;

    setState(() {
      _firstName = user.firstName;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String get _title {
    switch (_selectedIndex) {
      case 0:
        return 'NU BD Exchange';
      case 1:
        return 'My Cart';
      case 2:
        return _firstName.isEmpty ? 'Profile' : _firstName;
      default:
        return 'NU BD Exchange';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showLogo =
        _selectedIndex == 0 || _selectedIndex == 1;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: nuBlue,
          titleSpacing: 14.w,
          title: Row(
            children: [
              if (showLogo)
                Container(
                  width: 40.w,
                  height: 40.w,
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Image.asset(
                    'assets/images/nubdexchange_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Icon(
                        Icons.storefront,
                        color: nuBlue,
                        size: 23.sp,
                      );
                    },
                  ),
                ),
              if (showLogo) SizedBox(width: 10.w),
              Text(
                _title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            if (_selectedIndex == 0)
              IconButton(
                onPressed: () => _onTappedBar(1),
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 25.sp,
                ),
              ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            ProductScreen(),
            CartScreen(),
            ProfileScreen(),
          ],
          onPageChanged: (index) {
            if (!mounted) return;

            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        floatingActionButton: _selectedIndex == 2
            ? null
            : FloatingActionButton(
                backgroundColor: nuGold,
                foregroundColor: nuDarkBlue,
                elevation: 4,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chat feature opened'),
                    ),
                  );
                },
                child: const Icon(Icons.chat_outlined),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTappedBar,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: nuBlue,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11.sp,
          unselectedFontSize: 10.sp,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _onTappedBar(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _pageController.jumpToPage(index);
  }
}
