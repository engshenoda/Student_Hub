import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkedin/core/routes/route.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Widget child;
  const CustomBottomNavigationBar({super.key, required this.child});

  static const _routes = [
    Routes.Home,
    Routes.messahes,
    Routes.AddPost,
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        selectedIconTheme: const IconThemeData(size: 24, color: selectedColor),
        unselectedIconTheme: const IconThemeData(
          size: 22,
          color: unselectedColor,
        ),
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          if (index == 0) {
            GoRouter.of(context).push(Routes.Home);
          } else if (index == 1) {
            GoRouter.of(context).push(Routes.messahes);
          } else if (index == 2) {
            GoRouter.of(context).push(Routes.AddPost);
          } else if (index == 3) {
            GoRouter.of(context).push(Routes.jobs);
          } else if (index == 4) {
            GoRouter.of(context).push(Routes.profile);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
