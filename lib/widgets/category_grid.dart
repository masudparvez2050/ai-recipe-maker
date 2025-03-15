import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Breakfast', 'icon': '🍳'},
      {'name': 'Lunch', 'icon': '🍜'},
      {'name': 'Dinner', 'icon': '🍖'},
      {'name': 'Salad', 'icon': '🥗'},
      {'name': 'Dessert', 'icon': '🍰'},
      {'name': 'Fastfood', 'icon': '🍔'},
      {'name': 'Drink', 'icon': '🍹'},
      {'name': 'Cake', 'icon': '🎂'},
    ];

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive grid - adjust crossAxisCount based on available width
          int crossAxisCount = constraints.maxWidth ~/ 120;
          if (crossAxisCount < 2) crossAxisCount = 2;
          if (crossAxisCount > 6) crossAxisCount = 6;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.9,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(context, categories[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    Map<String, String> category,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // Handle category selection
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected: ${category['name']}')),
            );
          },
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.scale(scale: 0.9 + (0.1 * value), child: child);
            },
            child: Card(
              elevation: 4,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade100],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'category_${category['name']}',
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          category['icon']!,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      category['name']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
