import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'product_screen.dart';
import 'cart_screen.dart';

import '../widgets/custom_text.dart';

class HomeScreen
    extends StatefulWidget {
  final String username;

  const HomeScreen({
    super.key,
    this.username = '',
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageController
      _pageController =
      PageController();

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool isCartScreen =
        _selectedIndex == 1;

    return PopScope(
      canPop: false,
      child: Scaffold(
        // ======================================================
        // APP BAR
        // ======================================================

        appBar: AppBar(
          automaticallyImplyLeading:
              false,

          elevation: 2,

          backgroundColor:
              isCartScreen
                  ? const Color(
                      0xFF3949AB,
                    )
                  : null,

          foregroundColor:
              isCartScreen
                  ? Colors.white
                  : null,

          title:
              _selectedIndex == 0
                  ? Image.asset(
                      'assets/images/nubdexchange_logo.png',
                      scale: 11.sp,
                    )
                  : CustomText(
                      text:
                          _selectedIndex ==
                                  1
                              ? 'Cart'
                              : 'Profile',

                      fontSize:
                          20.sp,

                      fontWeight:
                          FontWeight
                              .w600,

                      color:
                          isCartScreen
                              ? Colors
                                  .white
                              : null,
                    ),

          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                size: 24.sp,
              ),

              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/settings',
                );
              },
            ),
          ],
        ),

        // ======================================================
        // BODY
        // ======================================================

        body: PageView(
          controller:
              _pageController,

          physics:
              const NeverScrollableScrollPhysics(),

          children: const [
            ProductScreen(),
            CartScreen(),
            SizedBox(),
          ],

          onPageChanged:
              (page) {
            setState(() {
              _selectedIndex =
                  page;
            });
          },
        ),

        // ======================================================
        // CHAT BUTTON
        // ======================================================

        // I show the chat button only on the home screen.
        floatingActionButton:
          _selectedIndex != 0
                ? null
                : FloatingActionButton(
                    backgroundColor:
                        const Color(
                      0xFF3949AB,
                    ),

                    foregroundColor:
                        Colors.white,

                    onPressed: () {
                      ScaffoldMessenger
                              .of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Chat feature opened',
                          ),
                        ),
                      );
                    },

                    child:
                        const Icon(
                      Icons.chat,
                    ),
                  ),

        // ======================================================
        // BOTTOM NAVIGATION
        // ======================================================

        bottomNavigationBar:
            BottomNavigationBar(
          currentIndex:
              _selectedIndex,

          onTap:
              onTappedBar,

          showSelectedLabels:
              false,

          showUnselectedLabels:
              false,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_bag,
              ),
              label: 'Shop',
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
              ),
              label: 'Cart',
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void onTappedBar(
    int value,
  ) {
    setState(() {
      _selectedIndex =
          value;
    });

    if (value == 2) {
      _pageController.jumpToPage(
        2,
      );
    } else {
      _pageController.jumpToPage(
        value,
      );
    }
  }
}