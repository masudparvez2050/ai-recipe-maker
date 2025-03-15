import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/recipe_option.dart';
import 'dart:convert';

class AIService {
  final String? apiKey;

  late final GenerativeModel _model;
  late final GenerativeModel _imageModel;

  AIService() : apiKey = dotenv.env['GEMINI_API_KEY'] {
    if (apiKey == null) {
      print('Warning: GEMINI_API_KEY not found in environment variables');
    }

    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey ?? '',
      generationConfig: GenerationConfig(
        temperature: 0.9,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
      ),
    );

    _imageModel = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey ?? '',
      generationConfig: GenerationConfig(
        temperature: 0.9,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
      ),
    );
  }

  Future<List<RecipeOption>> generateRecipeOptions(
    String prompt, {
    bool isVeg = false,
  }) async {
    try {
      final chat = _model.startChat();

      final dietType = isVeg ? 'vegetarian' : '';
      final message = '''
      ${dietType.isNotEmpty ? 'Generate only $dietType recipes.' : ''}
      Depends on user instruction create 3 different Recipe variant with Recipe Name with Emoji, 
      2 line description and main ingredient list in JSON format with field recipeName, description, ingredients (without size) only.
      
      User instruction: $prompt
      ''';

      final content = Content.text(message);
      final response = await chat.sendMessage(content);

      if (response.text == null) {
        throw Exception('Failed to generate recipe options');
      }

      // Extract JSON from the response
      final jsonStr = _extractJsonFromResponse(response.text!);
      final List<dynamic> jsonList = json.decode(jsonStr);

      return jsonList.map((json) => RecipeOption.fromJson(json)).toList();
    } catch (e) {
      print('Error generating recipe options: $e');
      // Return fallback options if API fails
      return _getFallbackRecipeOptions();
    }
  }

  Future<Recipe> generateDetailedRecipe(
    RecipeOption option, {
    bool isVeg = false,
  }) async {
    try {
      final chat = _model.startChat();

      final dietType = isVeg ? 'vegetarian' : '';
      final message = '''
      ${dietType.isNotEmpty ? 'Generate only $dietType recipes.' : ''}
      As per recipe Name and Description, Give me all list of ingredients as ingredient,
      emoji icons for each ingredient as icon, quantity as quantity, along with detail step by step recipe as steps
      Total Calories as calories (only number), Minutes to cook as cookTime and serving number as serveTo
      realistic image Text prompt as per recipe as imagePrompt
      
      Give me response in JSON format only
      
      Recipe Name: ${option.recipeName}
      Description: ${option.description}
      Main Ingredients: ${option.ingredients.join(', ')}
      ''';

      final content = Content.text(message);
      final response = await chat.sendMessage(content);

      if (response.text == null) {
        throw Exception('Failed to generate detailed recipe');
      }

      // Extract JSON from the response
      final jsonStr = _extractJsonFromResponse(response.text!);
      final Map<String, dynamic> recipeJson = json.decode(jsonStr);

      return Recipe.fromJson(recipeJson);
    } catch (e) {
      print('Error generating detailed recipe: $e');
      // Return fallback recipe if API fails
      return _getFallbackRecipe(option);
    }
  }

  Future<String> generateImagePrompt(Recipe recipe) async {
    try {
      final chat = _imageModel.startChat();

      final message = '''
      Create a detailed image generation prompt for this recipe:
      
      Recipe Name: ${recipe.recipeName}
      Description: ${recipe.description}
      
      The prompt should describe a professional food photography style image of this dish.
      ''';

      final content = Content.text(message);
      final response = await chat.sendMessage(content);

      return response.text ??
          "Delicious ${recipe.recipeName} on a plate, professional food photography";
    } catch (e) {
      print('Error generating image prompt: $e');
      return "Delicious ${recipe.recipeName} on a plate, professional food photography";
    }
  }

  String _extractJsonFromResponse(String response) {
    // Try to extract JSON from the response
    final jsonRegex = RegExp(r'```json\s*([\s\S]*?)\s*```');
    final match = jsonRegex.firstMatch(response);

    if (match != null && match.groupCount >= 1) {
      return match.group(1)!.trim();
    }

    // If no JSON code block is found, try to find JSON directly
    if (response.trim().startsWith('[') || response.trim().startsWith('{')) {
      return response.trim();
    }

    throw Exception('Could not extract JSON from response');
  }

  List<RecipeOption> _getFallbackRecipeOptions() {
    return [
      RecipeOption(
        recipeName: 'Creamy Chickpea & Potato Curry 🍛',
        description:
            'A rich and flavorful curry, perfect for a weeknight dinner. This dish combines tender potatoes and chickpeas in a creamy, spiced sauce.',
        ingredients: ['Chickpeas', 'Potatoes', 'Coconut Milk', 'Curry Powder'],
      ),
      RecipeOption(
        recipeName: 'Spicy Chickpea & Potato Salad 🥗',
        description:
            'A vibrant and zesty salad with a kick! Roasted chickpeas and potatoes are tossed with fresh herbs and a spicy dressing.',
        ingredients: ['Chickpeas', 'Potatoes', 'Lemon', 'Chili'],
      ),
      RecipeOption(
        recipeName: 'Simple Chickpea & Potato Soup 🥣',
        description:
            'A comforting and hearty soup, easy to make and full of flavor. This soup blends chickpeas and potatoes into a smooth, warming broth.',
        ingredients: ['Chickpeas', 'Potatoes', 'Vegetable Broth', 'Herbs'],
      ),
    ];
  }

  Recipe _getFallbackRecipe(RecipeOption option) {
    return Recipe(
      recipeName: option.recipeName,
      description: option.description,
      ingredients: [
        Ingredient(name: 'Potatoes', icon: '🥔', quantity: '2 medium, cubed'),
        Ingredient(
          name: 'Chickpeas',
          icon: '🫘',
          quantity: '1 can (15 ounces)',
        ),
        Ingredient(name: 'Onion', icon: '🧅', quantity: '1 medium, chopped'),
        Ingredient(name: 'Garlic', icon: '🧄', quantity: '2 cloves, minced'),
      ],
      steps: [
        'Heat oil in a large pot over medium heat. Add onion and cook until softened, about 5 minutes.',
        'Add garlic and ginger and cook for 1 minute more, until fragrant.',
        'Stir in spices and cook for another minute, allowing the spices to bloom.',
        'Add main ingredients and cook according to recipe type.',
      ],
      calories: 493,
      cookTime: 30,
      serveTo: 4,
      imagePrompt:
          'Delicious ${option.recipeName} on a plate, professional food photography',
    );
  }
}
