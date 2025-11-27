import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Widget child;
  const CustomBottomNavigationBar({super.key, required this.child});

  static const _routes = [
    Routes.home,
    Routes.messahes,
    Routes.addPostScreen,
    Routes.jobs,
    Routes.profile,
  ];

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _locationToIndex(String location) {
    for (var i = 0; i < CustomBottomNavigationBar._routes.length; i++) {
      if (location == CustomBottomNavigationBar._routes[i] ||
          location.startsWith('${CustomBottomNavigationBar._routes[i]}/')) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final GoRouterState state = GoRouterState.of(context);
    final currentLocation = state.uri.toString();
    int currentIndex = _locationToIndex(currentLocation);

    const selectedColor = Color(0xFF00B894);
    const unselectedColor = Colors.grey;

    return Scaffold(
      body: widget.child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Routes.addPostScreen),
        backgroundColor: selectedColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_rounded,
                label: 'Home',
                route: Routes.home,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
              ),
              _buildNavItem(
                context,
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat',
                route: Routes.messahes,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
              ),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(
                context,
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.work_outline_rounded,
                label: 'Jobs',
                route: Routes.jobs,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
              ),
              _buildNavItem(
                context,
                index: 4,
                currentIndex: currentIndex,
                icon: Icons.search_rounded,
                label: 'Search',
                route: Routes.search,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required int currentIndex,
    required IconData icon,
    required String label,
    required String route,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () {
        if (currentIndex != index) {
          context.go(route);
        }
      },
      customBorder: const CircleBorder(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? selectedColor : unselectedColor,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? selectedColor : unselectedColor,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
