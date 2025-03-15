class Recipe {
  final String recipeName;
  final String description;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final int calories;
  final int cookTime;
  final int serveTo;
  final String imagePrompt;
  String? imageUrl;

  Recipe({
    required this.recipeName,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.calories,
    required this.cookTime,
    required this.serveTo,
    required this.imagePrompt,
    this.imageUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredientsList = [];
    if (json['ingredients'] != null) {
      if (json['ingredients'] is List) {
        ingredientsList = List<Ingredient>.from(
          json['ingredients'].map((x) => Ingredient.fromJson(x)),
        );
      }
    }

    List<String> stepsList = [];
    if (json['steps'] != null) {
      if (json['steps'] is List) {
        stepsList = List<String>.from(json['steps']);
      }
    }

    return Recipe(
      recipeName: json['recipeName'] ?? '',
      description: json['description'] ?? '',
      ingredients: ingredientsList,
      steps: stepsList,
      calories: json['calories'] is int ? json['calories'] : int.tryParse(json['calories'].toString()) ?? 0,
      cookTime: json['cookTime'] is int ? json['cookTime'] : int.tryParse(json['cookTime'].toString()) ?? 0,
      serveTo: json['serveTo'] is int ? json['serveTo'] : int.tryParse(json['serveTo'].toString()) ?? 0,
      imagePrompt: json['imagePrompt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeName': recipeName,
      'description': description,
      'ingredients': ingredients.map((x) => x.toJson()).toList(),
      'steps': steps,
      'calories': calories,
      'cookTime': cookTime,
      'serveTo': serveTo,
      'imagePrompt': imagePrompt,
      'imageUrl': imageUrl,
    };
  }
}

class Ingredient {
  final String name;
  final String icon;
  final String quantity;

  Ingredient({
    required this.name,
    required this.icon,
    required this.quantity,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['ingredient'] ?? json['name'] ?? '',
      icon: json['icon'] ?? '🍴',
      quantity: json['quantity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'quantity': quantity,
    };
  }
}