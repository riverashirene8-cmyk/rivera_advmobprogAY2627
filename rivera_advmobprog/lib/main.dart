import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/cart_screen.dart';

import 'providers/theme_provider.dart';
import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await dotenv.load(
    fileName: 'assets/.env',
  );

  runApp(
    const RiveraAdvMobProg(),
  );
}

class RiveraAdvMobProg
    extends StatelessWidget {
  const RiveraAdvMobProg({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize:
            const Size(412, 715),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final themeModel =
              context.watch<ThemeProvider>();

          return MaterialApp(
            debugShowCheckedModeBanner:
                false,
            title: 'E-Commerce App',

            theme:
                themeModel.lightTheme,

            darkTheme:
                themeModel.darkTheme,

            themeMode:
                themeModel.isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,

            initialRoute: '/home',

            routes: {
              '/home': (_) =>
                  const HomeScreen(),

              '/settings': (_) =>
                  const SettingsScreen(),

              '/cart': (_) =>
                  const CartScreen(),
            },
          );
        },
      ),
    );
  }
}