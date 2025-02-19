import 'package:shared_preferences/shared_preferences.dart';

class TabPreference {
  static const String _selectedTabKey = 'selectedTab';

  static Future<void> saveSelectedTab(int tabIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedTabKey, tabIndex);
  }

  static Future<int> getSelectedTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedTabKey) ?? 0;
  }
}