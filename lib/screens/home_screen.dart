import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/auth_provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/screens/recipe_options_screen.dart';
import 'package:recipe_app/services/ai_service.dart';
import 'package:recipe_app/widgets/category_grid.dart';
import 'package:recipe_app/widgets/bottom_nav.dart';
import 'package:recipe_app/constants/assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generateRecipes() async {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter what you want to cook')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final recipeProvider = Provider.of<RecipeProvider>(
        context,
        listen: false,
      );
      final aiService = Provider.of<AIService>(context, listen: false);

      final options = await aiService.generateRecipeOptions(
        _promptController.text,
        isVeg: recipeProvider.isVegetarian,
      );

      recipeProvider.setRecipeOptions(options);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecipeOptionsScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating recipes: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${authProvider.username}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        recipeProvider.isVegetarian ? 'Vegetarian' : 'Non-Veg',
                        style: TextStyle(
                          color:
                              recipeProvider.isVegetarian
                                  ? Colors.green
                                  : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: recipeProvider.isVegetarian,
                        onChanged: (value) {
                          recipeProvider.toggleVegetarian();
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.startCookingIcon,
                        width: 30,
                        height: 30,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.restaurant, size: 30),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Warm up your stove, and let\'s get cooking!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Make something for your LOVE',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _promptController,
                    decoration: InputDecoration(
                      hintText:
                          'What you want to create today? Add ingredients etc',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isGenerating ? null : _generateRecipes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        _isGenerating
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Generate Recipe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const CategoryGrid(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
