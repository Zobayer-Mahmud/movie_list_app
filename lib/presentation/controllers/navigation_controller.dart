import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<NavigationItem> navigationItems = [
    NavigationItem(
      icon: Icons.movie_outlined,
      activeIcon: Icons.movie,
      label: 'Movies',
      route: '/movies',
    ),
    NavigationItem(
      icon: Icons.favorite_border,
      activeIcon: Icons.favorite,
      label: 'Favorites',
      route: '/favorites',
    ),
    NavigationItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Statistics',
      route: '/statistics',
    ),
    NavigationItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Search',
      route: '/search',
    ),
    NavigationItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
      route: '/settings',
    ),
  ];

  void changePage(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      Get.offAllNamed(navigationItems[index].route);
    }
  }

  void navigateToPage(String route) {
    final index = navigationItems.indexWhere((item) => item.route == route);
    if (index != -1) {
      selectedIndex.value = index;
    }
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
