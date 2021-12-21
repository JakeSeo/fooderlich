import 'package:flutter/material.dart';

// 1 "TabManager" manages the tab index that the user taps. This allows the
// object to provide change notifications to its listeners.
class TabManager extends ChangeNotifier {
  // 2 "selectedTab" keeps track of which tab the user tapped.
  int selectedTab = 0;

  // 3 "goToTab" is a simple function that modifies the current tab index.
  void goToTab(index) {
    // 4 Stores the index of the new tab the user tapped.
    selectedTab = index;
    // 5 Calls "notifyListeners()" to notify all widgets listening to this state
    notifyListeners();
  }

  // 6 "goToRecipes() is a specific function that sets "selectedTab" to the
  // Recipes tab, which is at index 1.
  void goToRecipes() {
    selectedTab = 1;
    // 7 Notifies all widgets listening to TabManager that Recipes is the
    // selected tab.
    notifyListeners();
  }
}
