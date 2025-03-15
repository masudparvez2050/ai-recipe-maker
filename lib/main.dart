import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/providers/auth_provider.dart';
import 'package:recipe_app/screens/splash_screen.dart';
import 'package:recipe_app/services/ai_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

Future<void> main() async {
  // Load environment variables before anything else
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        Provider(create: (_) => AIService()),
      ],
      child: MaterialApp(
        title: 'Cookmate AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
