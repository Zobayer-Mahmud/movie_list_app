import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return IconButton(
        onPressed: themeController.toggleTheme,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return RotationTransition(turns: animation, child: child);
          },
          child: Icon(
            themeController.isDarkMode
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            key: ValueKey(themeController.isDarkMode),
          ),
        ),
        tooltip: themeController.isDarkMode
            ? 'Switch to Light Mode'
            : 'Switch to Dark Mode',
      );
    });
  }
}
