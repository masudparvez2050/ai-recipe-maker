import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:recipe_app/constants/assets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipe = recipeProvider.currentRecipe!;
    final isSaved = recipeProvider.isRecipeSaved(recipe);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Recipe Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                key: ValueKey<bool>(isSaved),
                color: Colors.white,
              ),
            ),
            onPressed: () {
              if (isSaved) {
                recipeProvider.removeRecipe(recipe);
              } else {
                recipeProvider.saveRecipe(recipe);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              final recipe = recipeProvider.currentRecipe!;
              final text = '''
${recipe.recipeName}

Description:
${recipe.description}

Ingredients:
${recipe.ingredients.map((i) => '${i.icon} ${i.name} - ${i.quantity}').join('\n')}

Steps:
${recipe.steps.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n')}

Calories: ${recipe.calories} Cal
Cook Time: ${recipe.cookTime} Min
Serves: ${recipe.serveTo} People
''';
              Share.share(text);
            },
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
              minHeight: MediaQuery.of(context).size.height * 0.3,
              builder: (_, shrinkOffset, overlapsContent) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'recipe-${recipe.recipeName.replaceAll(' ', '_')}',
                      child:
                          recipe.imageUrl != null
                              ? Image.network(
                                recipe.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppAssets.defaultRecipeImage,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                              : Image.asset(
                                AppAssets.defaultRecipeImage,
                                fit: BoxFit.cover,
                              ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.recipeName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(blurRadius: 5, color: Colors.black45),
                              ],
                            ),
                          ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
                          const SizedBox(height: 8),
                          Opacity(
                            opacity: 0.8,
                            child: Text(
                              recipe.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                shadows: [
                                  Shadow(blurRadius: 3, color: Colors.black45),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoCard(
                          icon: Icons.local_fire_department,
                          label: 'Calories',
                          value: '${recipe.calories} Cal',
                          color: Colors.deepOrange,
                          delay: 0,
                        ),
                        _buildInfoCard(
                          icon: Icons.timer,
                          label: 'Time',
                          value: '${recipe.cookTime} Min',
                          color: Colors.blue,
                          delay: 100,
                        ),
                        _buildInfoCard(
                          icon: Icons.people_alt_rounded,
                          label: 'Serves',
                          value: '${recipe.serveTo}',
                          color: Colors.green,
                          delay: 200,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildSectionTitle(
                      'Ingredients',
                      '${recipe.ingredients.length} Items',
                    ),
                  ),
                  _buildIngredientsList(recipe),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildSectionTitle(
                      'Preparation',
                      '${recipe.steps.length} Steps',
                    ),
                  ),
                  _buildStepsList(recipe),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _buildCookingPrompt(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Start cooking action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enjoy your cooking!')),
              );
            },
            label: const Text('Start Cooking'),
            icon: const Icon(Icons.restaurant),
            backgroundColor: Theme.of(context).colorScheme.primary,
          )
          .animate()
          .fade(duration: 600.ms, delay: 300.ms)
          .move(
            begin: const Offset(0, 20),
            end: const Offset(0, 0),
            duration: 600.ms,
            delay: 300.ms,
          ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required int delay,
  }) {
    return Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildIngredientsList(Recipe recipe) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: recipe.ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = recipe.ingredients[index];
        return Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length]
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      ingredient.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                title: Text(
                  ingredient.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ingredient.quantity,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
            .animate(delay: Duration(milliseconds: 100 * index))
            .fadeIn(duration: 400.ms)
            .slideX(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildStepsList(Recipe recipe) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: recipe.steps.length,
      itemBuilder: (context, index) {
        return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Step ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          recipe.steps[index],
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                ],
              ),
            )
            .animate(delay: Duration(milliseconds: 150 * index))
            .fadeIn(duration: 500.ms);
      },
    );
  }

  Widget _buildCookingPrompt() {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Image.asset(
                  AppAssets.cookingIcon,
                  width: 60,
                  height: 60,
                ).animate().scale(
                  duration: 800.ms,
                  curve: Curves.easeInOut,
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ready to cook something amazing?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                const SizedBox(height: 12),
                const Text(
                  'Follow these steps to create a delicious meal for yourself and your loved ones',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 800.ms)
        .scale(
          delay: 200.ms,
          duration: 500.ms,
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
        );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;
  final Widget Function(BuildContext, double, bool) builder;

  _SliverAppBarDelegate({
    required this.maxHeight,
    required this.minHeight,
    required this.builder,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return builder(context, shrinkOffset, overlapsContent);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}
