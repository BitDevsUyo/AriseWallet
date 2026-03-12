import 'package:bitdevs_project/core/cachemanager.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  final CacheManager _cacheManager = CacheManager();

  Future<void> initTheme() async {
    try {
      final savedTheme = await _cacheManager.getApptheme();
      if (savedTheme != null) {
        _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
        dev.log('Theme loaded from cache: $savedTheme');
        notifyListeners();
      } else {
        dev.log('No saved theme, using light mode');
      }
    } catch (e) {
      dev.log('Error loading theme: $e');
    }
  }
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setDarkMode();
    } else {
      await setLightMode();
    }
  }

  Future<void> setDarkMode() async {
    _themeMode = ThemeMode.dark;
    await _cacheManager.saveApptheme('dark');
    dev.log('Theme changed to dark');
    notifyListeners();
  }
  Future<void> setLightMode() async {
    _themeMode = ThemeMode.light;
    await _cacheManager.saveApptheme('light');
    dev.log('Theme changed to light');
    notifyListeners();
  }

  /// Set theme by ThemeMode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final themeName = mode == ThemeMode.dark ? 'dark' : 'light';
    await _cacheManager.saveApptheme(themeName);
    dev.log('Theme changed to $themeName');
    notifyListeners();
  }
}