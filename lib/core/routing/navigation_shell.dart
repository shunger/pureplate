import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

/// Bottom navigation scaffold wrapping the 4 main tabs.
class NavigationShell extends StatelessWidget {
  final GoRouterState state;
  final Widget child;

  const NavigationShell({
    super.key,
    required this.state,
    required this.child,
  });

  int _currentIndex(String location) {
    if (location.startsWith(Routes.pantry)) return 1;
    if (location.startsWith(Routes.planner)) return 2;
    if (location.startsWith(Routes.lists)) return 3;
    return 0; // home
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(state.uri.path);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go(Routes.home);
            case 1:
              context.go(Routes.pantry);
            case 2:
              context.go(Routes.planner);
            case 3:
              context.go(Routes.lists);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen_outlined),
            activeIcon: Icon(Icons.kitchen),
            label: 'Pantry',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Lists',
          ),
        ],
      ),
    );
  }
}
