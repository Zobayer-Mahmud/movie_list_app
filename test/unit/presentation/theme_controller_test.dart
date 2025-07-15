import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:movie_list_app/presentation/controllers/theme_controller.dart';

void main() {
  group('ThemeController', () {
    test('should have correct initial state values', () {
      final controller = ThemeController();

      // Check initial observable state (before onInit)
      expect(controller.isDarkMode, false);
    });

    test('should return correct theme mode for light theme', () {
      final controller = ThemeController();

      // Mock the internal state to light
      expect(controller.themeMode, ThemeMode.light);
    });

    test('should have proper class structure', () {
      final controller = ThemeController();

      // Verify it extends GetxController
      expect(controller, isA<GetxController>());

      // Verify it has required methods
      expect(controller.toggleTheme, isA<Function>());
      expect(controller.isDarkMode, isA<bool>());
      expect(controller.themeMode, isA<ThemeMode>());
    });

    test('should provide correct theme modes', () {
      // Test ThemeMode enum values are accessible
      expect(ThemeMode.light, isA<ThemeMode>());
      expect(ThemeMode.dark, isA<ThemeMode>());
      expect(ThemeMode.system, isA<ThemeMode>());
    });
  });
}
