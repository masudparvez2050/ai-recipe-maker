import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/recipe_option.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeProvider extends ChangeNotifier {
  List<RecipeOption> _recipeOptions = [];
  Recipe? _currentRecipe;
  List<Recipe> _savedRecipes = [];
  bool _isVegetarian = false;
  bool _isLoading = false;
  
  RecipeProvider() {
    _loadSavedRecipes();
  }

  List<RecipeOption> get recipeOptions => _recipeOptions;
  Recipe? get currentRecipe => _currentRecipe;
  List<Recipe> get savedRecipes => _savedRecipes;
  bool get isVegetarian => _isVegetarian;
  bool get isLoading => _isLoading;

  void setRecipeOptions(List<RecipeOption> options) {
    _recipeOptions = options;
    notifyListeners();
  }

  void setCurrentRecipe(Recipe recipe) {
    _currentRecipe = recipe;
    notifyListeners();
  }

  void toggleVegetarian() {
    _isVegetarian = !_isVegetarian;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void saveRecipe(Recipe recipe) {
    if (!_savedRecipes.any((r) => r.recipeName == recipe.recipeName)) {
      _savedRecipes.add(recipe);
      _saveToDisk();
      notifyListeners();
    }
  }

  void removeRecipe(Recipe recipe) {
    _savedRecipes.removeWhere((r) => r.recipeName == recipe.recipeName);
    _saveToDisk();
    notifyListeners();
  }

  bool isRecipeSaved(Recipe recipe) {
    return _savedRecipes.any((r) => r.recipeName == recipe.recipeName);
  }
  
  Future<void> _loadSavedRecipes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRecipesJson = prefs.getStringList('savedRecipes') ?? [];
      
      _savedRecipes = savedRecipesJson
          .map((recipeJson) => Recipe.fromJson(json.decode(recipeJson)))
          .toList();
      
      _isVegetarian = prefs.getBool('isVegetarian') ?? false;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading saved recipes: $e');
    }
  }

  Future<void> _saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRecipesJson = _savedRecipes
          .map((recipe) => json.encode(recipe.toJson()))
          .toList();
      
      await prefs.setStringList('savedRecipes', savedRecipesJson);
      await prefs.setBool('isVegetarian', _isVegetarian);
    } catch (e) {
      debugPrint('Error saving recipes: $e');
    }
  }
}