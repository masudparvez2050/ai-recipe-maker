import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/recipe_option.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/screens/recipe_detail_screen.dart';
import 'package:recipe_app/services/ai_service.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

class RecipeOptionsScreen extends StatefulWidget {
  const RecipeOptionsScreen({super.key});

  @override
  State<RecipeOptionsScreen> createState() => _RecipeOptionsScreenState();
}

class _RecipeOptionsScreenState extends State<RecipeOptionsScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  int? _selectedIndex;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generateDetailedRecipe(RecipeOption option) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recipeProvider = Provider.of<RecipeProvider>(
        context,
        listen: false,
      );
      final aiService = Provider.of<AIService>(context, listen: false);

      final recipe = await aiService.generateDetailedRecipe(
        option,
        isVeg: recipeProvider.isVegetarian,
      );

      recipeProvider.setCurrentRecipe(recipe);

      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder:
                (_, animation, __) => FadeTransition(
                  opacity: animation,
                  child: const RecipeDetailScreen(),
                ),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating detailed recipe: $e'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _selectedIndex = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeOptions = Provider.of<RecipeProvider>(context).recipeOptions;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select a Recipe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimationLimiter(
        child: GridView.builder(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 2 : 1,
            childAspectRatio: isTablet ? 1.5 : 1.3,
            crossAxisSpacing: isTablet ? 20 : 0,
            mainAxisSpacing: isTablet ? 20 : 16,
          ),
          itemCount: recipeOptions.length,
          itemBuilder: (context, index) {
            final option = recipeOptions[index];
            final isSelected = _selectedIndex == index;

            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: isTablet ? 2 : 1,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Hero(
                    tag: 'recipe_${option.recipeName}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: _buildRecipeCard(option, index, isSelected),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecipeCard(RecipeOption option, int index, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform:
          isSelected ? (Matrix4.identity()..scale(0.98)) : Matrix4.identity(),
      child: Card(
        elevation: isSelected ? 2 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
          highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
          onTap:
              _isLoading
                  ? null
                  : () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    _generateDetailedRecipe(option);
                  },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.recipeName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      option.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  if (isSelected && _isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 120,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
