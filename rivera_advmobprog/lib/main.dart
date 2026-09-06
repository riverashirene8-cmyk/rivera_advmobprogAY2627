import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';

import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
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
  const RiveraAdvMobProg({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              ThemeProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              CartProvider(),
        ),
      ],

      child: ScreenUtilInit(
        designSize:
            const Size(412, 715),
        minTextAdapt: true,
        splitScreenMode: true,

        builder:
            (context, child) {
          final themeModel =
              context.watch<
                  ThemeProvider>();

          return MaterialApp(
            debugShowCheckedModeBanner:
                false,

            title:
                'NUBD Exchange',

            theme:
                themeModel.lightTheme,

            darkTheme:
                themeModel.darkTheme,

            themeMode:
                themeModel.isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,

            // SAMPLE OUTPUT STARTS HERE
            initialRoute:
                '/splash',

            routes: {
              '/splash': (_) =>
                  const SplashScreen(),

              '/signin': (_) =>
                  const SignInScreen(),

              '/home': (_) =>
                  const HomeScreen(),

              '/settings': (_) =>
                  const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}