import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  final UserService _userService =
      UserService();

  @override
  void initState() {
    super.initState();

    _checkAuthentication();
  }

  // ENHANCEMENT 1:
  // Implements persistent authentication by checking
  // the saved login information through UserService.
  // If the user is already authenticated, the app
  // navigates directly to the HomeScreen. Otherwise,
  // the user is redirected to the SignInScreen.
  Future<void> _checkAuthentication() async {
    await Future.delayed(
      const Duration(
        milliseconds: 1500,
      ),
    );

    final loggedIn =
        await _userService.isLoggedIn();

    if (!mounted) {
      return;
    }

    if (loggedIn) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/signin',
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFFF8FF),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/nubdexchange_logo.png',
              width: 110.w,
              height: 110.h,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  Icon(
                    Icons.shopping_bag,
                    size: 80.sp,
                  ),
            ),

            SizedBox(height: 18.h),

            Text(
              'NUBD Exchange',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            SizedBox(height: 20.h),

            SizedBox(
              width: 25.w,
              height: 25.h,
              child:
                  const CircularProgressIndicator(
                strokeWidth: 2,
                color:
                    Color(0xFFFFC107),
              ),
            ),
          ],
        ),
      ),
    );
  }
}