import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../widgets/custom_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Settings',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 8.w),
              leading: Icon(
                themeModel.isDark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                size: 24.sp,
              ),
              title: CustomText(
                text: 'Dark Mode',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              trailing: Switch(
                value: themeModel.isDark,
                onChanged: (value) {
                  context
                      .read<ThemeProvider>()
                      .toggleTheme(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}