import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeController extends GetxController {
  static const String _themeBoxName = 'themeBox';
  static const String _themeKey = 'isDarkMode';

  late Box<bool> _themeBox;
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initThemeBox();
    _loadTheme();
  }

  Future<void> _initThemeBox() async {
    try {
      _themeBox = await Hive.openBox<bool>(_themeBoxName);
    } catch (e) {
      // If box fails to open, create a new one
      await Hive.deleteBoxFromDisk(_themeBoxName);
      _themeBox = await Hive.openBox<bool>(_themeBoxName);
    }
  }

  void _loadTheme() {
    final savedTheme = _themeBox.get(_themeKey, defaultValue: false);
    _isDarkMode.value = savedTheme ?? false;
  }

  Future<void> toggleTheme() async {
    try {
      _isDarkMode.value = !_isDarkMode.value;
      await _themeBox.put(_themeKey, _isDarkMode.value);

      // Update GetX theme
      Get.changeThemeMode(themeMode);

      // Show feedback
      Get.snackbar(
        'Theme',
        'Switched to ${_isDarkMode.value ? 'Dark' : 'Light'} mode',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        backgroundColor: Get.theme.colorScheme.inverseSurface.withOpacity(0.8),
        colorText: Get.theme.colorScheme.onInverseSurface,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save theme preference',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  @override
  void onClose() {
    _themeBox.close();
    super.onClose();
  }
}
