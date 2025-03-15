import 'package:flutter/material.dart';
import 'package:recipe_app/screens/recipe_options_screen.dart';

class RecipeInput extends StatefulWidget {
  const RecipeInput({super.key});

  @override
  State<RecipeInput> createState() => _RecipeInputState();
}

class _RecipeInputState extends State<RecipeInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _textController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: isWideScreen ? constraints.maxWidth * 0.1 : 16,
                vertical: 16,
              ),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with animated icon
                  Center(
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 1),
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            color: Colors.blue.shade400,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Let\'s create something delicious',
                            style: TextStyle(
                              fontSize: isWideScreen ? 22 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle with animation
                  Center(
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Opacity(opacity: value, child: child);
                      },
                      child: Text(
                        'Made with love, served with passion',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: isWideScreen ? 16 : 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Text input with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isTyping ? 120 : 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(
                            _isTyping ? 0.1 : 0.05,
                          ),
                          blurRadius: _isTyping ? 10 : 5,
                          spreadRadius: _isTyping ? 2 : 0,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: _isTyping ? 4 : 1,
                      onTap: () => setState(() => _isTyping = true),
                      onTapOutside: (_) => setState(() => _isTyping = false),
                      style: TextStyle(fontSize: isWideScreen ? 17 : 15),
                      decoration: InputDecoration(
                        hintText:
                            'What would you like to cook today? Add ingredients...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: Icon(
                          Icons.food_bank,
                          color: Colors.amber.shade400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Button with hover effect
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.95 + (0.05 * value),
                          child: child,
                        );
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, animation, __) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: const RecipeOptionsScreen(),
                                );
                              },
                              transitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                          minimumSize: Size(
                            double.infinity,
                            isWideScreen ? 60 : 50,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Generate Recipe',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 800),
                              builder: (context, value, child) {
                                return Transform.rotate(
                                  angle: value * 2 * 3.14,
                                  child: child,
                                );
                              },
                              child: Icon(
                                Icons.auto_awesome,
                                size: 20,
                                color: Colors.yellow.shade200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
