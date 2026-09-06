import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final UserService _userService =
      UserService();

  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();

    // ENHANCEMENT 3:
    // Retrieves the saved user data from UserService
    // and uses the User model to render the profile.
    _userFuture = _userService.getUser();
  }

  Future<void> _logout() async {
    await _userService.logout();

    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/signin',
      (route) => false,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SafeArea(
      child: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load profile.',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No user data found.',
              ),
            );
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface,
                    borderRadius:
                        BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.05,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42.r,
                        backgroundColor:
                            const Color(0xFFFFF8FF),
                        backgroundImage:
                            user.image.isNotEmpty
                                ? NetworkImage(
                                    user.image,
                                  )
                                : null,
                        child: user.image.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 40,
                              )
                            : null,
                      ),

                      SizedBox(height: 10.h),

                      // Render the saved user's full name.
                      Text(
                        user.fullName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Render the saved username.
                      Text(
                        '@${user.username}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                _infoTile(
                  Icons.email,
                  'Email',
                  user.email,
                ),

                _infoTile(
                  Icons.person,
                  'Gender',
                  user.gender,
                ),

                // User ID is taken from the saved User model.
                _infoTile(
                  Icons.badge,
                  'User ID',
                  '#${user.id}',
                ),

                if (user.phone.isNotEmpty)
                  _infoTile(
                    Icons.phone,
                    'Phone',
                    user.phone,
                  ),

                SizedBox(height: 12.h),

                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(
                      Icons.logout,
                    ),
                    label: const Text(
                      'Log Out',
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFFF5F52),
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          10.r,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 1.h,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 18.sp,
          color: const Color(0xFFFFC107),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }
}