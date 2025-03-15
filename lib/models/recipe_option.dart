class RecipeOption {
  final String recipeName;
  final String description;
  final List<String> ingredients;

  RecipeOption({
    required this.recipeName,
    required this.description,
    required this.ingredients,
  });

  factory RecipeOption.fromJson(Map<String, dynamic> json) {
    return RecipeOption(
      recipeName: json['recipeName'] ?? '',
      description: json['description'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeName': recipeName,
      'description': description,
      'ingredients': ingredients,
    };
  }
}