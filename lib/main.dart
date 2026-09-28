import 'package:flutter/material.dart';
import 'showcase/screens/gallery_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterCraftApp());
}

class FlutterCraftApp extends StatefulWidget {
  const FlutterCraftApp({super.key});

  @override
  State<FlutterCraftApp> createState() => _FlutterCraftAppState();
}

class _FlutterCraftAppState extends State<FlutterCraftApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFACC15); // Vibrant Pacman / Craft Accent
    const lightWarmBg = Color(0xFFEEEAE3); // Reference warm yellowish off-white

    return MaterialApp(
      title: 'Flutter Craft',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: lightWarmBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          surface: lightWarmBg,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: lightWarmBg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F12),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          surface: const Color(0xFF18181B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0F12),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: GalleryScreen(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
