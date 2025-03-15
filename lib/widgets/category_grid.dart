import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categories = [
      {
        'name': 'Breakfast',
        'icon': Icons.breakfast_dining,
        'color': Colors.amber,
      },
      {'name': 'Lunch', 'icon': Icons.lunch_dining, 'color': Colors.orange},
      {
        'name': 'Dinner',
        'icon': Icons.dinner_dining,
        'color': Colors.deepPurple,
      },
      {'name': 'Desserts', 'icon': Icons.icecream, 'color': Colors.pink},
      {'name': 'Snacks', 'icon': Icons.cookie, 'color': Colors.teal},
      {'name': 'Drinks', 'icon': Icons.local_bar, 'color': Colors.blue},
      {'name': 'Soups', 'icon': Icons.soup_kitchen, 'color': Colors.deepOrange},
      {'name': 'Salads', 'icon': Icons.eco, 'color': Colors.green},
    ];

    return SizedBox(
      height: size.width > 600 ? 240 : 200,
      child: AnimationLimiter(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final category = categories[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.all(8),
                    child: Material(
                      borderRadius: BorderRadius.circular(24),
                      elevation: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          // Handle category selection
                        },
                        splashColor: (category['color'] as Color).withOpacity(
                          0.2,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (category['color'] as Color).withOpacity(0.2),
                                (category['color'] as Color).withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: (category['color'] as Color).withOpacity(
                                0.3,
                              ),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: (category['color'] as Color)
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  category['icon'] as IconData,
                                  color: category['color'] as Color,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                category['name'] as String,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(10 + index * 5)} recipes',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
