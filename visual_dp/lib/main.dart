import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/visual_dp_screen.dart';
import 'package:flutter/services.dart';


void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]);
  
  runApp(
    const ProviderScope(
      child: VisualDPApp(),
    ),
  );
}


class VisualDPApp extends StatelessWidget {
  const VisualDPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VisualDP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF424242), // Dark Grey
          secondary: Color(0xFF616161), // Slightly lighter dark grey
        ),
        scaffoldBackgroundColor: const Color(0xFF121212), // Almost black
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E), // Very dark grey
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2C2C2C), // Input field dark background
          border: OutlineInputBorder(),
          hintStyle: TextStyle(color: Color(0xFFBDBDBD)), // Light grey hint
          labelStyle: TextStyle(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.grey),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF424242), // Button background
            foregroundColor: Colors.white, // Button text/icon
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
      ),
      home: const VisualDPScreen(),
    );
  }
}
