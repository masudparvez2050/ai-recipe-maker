import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Function(int)? onTabChanged;
  final int initialIndex;

  const BottomNav({super.key, this.onTabChanged, this.initialIndex = 0});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
      if (widget.onTabChanged != null) {
        widget.onTabChanged!(index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.95),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          items: _buildNavItems(),
          currentIndex: _selectedIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey.shade600,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems() {
    return [
      _buildNavItem(Icons.home_rounded, Icons.home_outlined, 'Home', 0),
      _buildNavItem(
        Icons.explore_rounded,
        Icons.explore_outlined,
        'Explore',
        1,
      ),
      BottomNavigationBarItem(
        icon: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                Theme.of(
                  context,
                ).colorScheme.primary, // Use solid color instead of gradient
          ),
          child: Center(
            child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
        ),
        label: 'Create',
      ),
      _buildNavItem(Icons.book_rounded, Icons.book_outlined, 'Cookbook', 3),
      _buildNavItem(
        Icons.person_rounded,
        Icons.person_outline_rounded,
        'Profile',
        4,
      ),
    ];
  }

  BottomNavigationBarItem _buildNavItem(
    IconData selectedIcon,
    IconData unselectedIcon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child:
            _selectedIndex == index
                ? Icon(selectedIcon, key: ValueKey('selected-$index'))
                : Icon(unselectedIcon, key: ValueKey('unselected-$index')),
      ),
      label: label,
    );
  }
}
