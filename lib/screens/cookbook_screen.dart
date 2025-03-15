import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipe_provider.dart';
import 'package:recipe_app/screens/recipe_detail_screen.dart';
import 'package:recipe_app/widgets/bottom_nav.dart';
import 'package:recipe_app/constants/assets.dart';

class CookbookScreen extends StatefulWidget {
  const CookbookScreen({super.key});

  @override
  State<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends State<CookbookScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final savedRecipes = recipeProvider.savedRecipes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookbook'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'User Created'), Tab(text: 'Saved Recipes')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // User Created tab
          const Center(child: Text('No recipes created yet')),

          // Saved Recipes tab
          savedRecipes.isEmpty
              ? const Center(child: Text('No saved recipes yet'))
              : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: savedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = savedRecipes[index];
                  return GestureDetector(
                    onTap: () {
                      recipeProvider.setCurrentRecipe(recipe);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecipeDetailScreen(),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 2.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child:
                                recipe.imageUrl != null
                                    ? Image.network(
                                      recipe.imageUrl!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey[400],
                                          ),
                                        );
                                      },
                                    )
                                    : Image.asset(
                                      AppAssets.defaultRecipeImage,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey[400],
                                          ),
                                        );
                                      },
                                    ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              recipe.recipeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
