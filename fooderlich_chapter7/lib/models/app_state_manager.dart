import 'dart:async';
import 'package:flutter/material.dart';

// 1 Creates constants for each tab the user taps.
class FooderlichTab {
  static const int explore = 0;
  static const int recipes = 1;
  static const int toBuy = 2;
}

class AppStateManager extends ChangeNotifier {
  // 2 "_initialized" checks if the app is initialized.
  bool _initialized = false;
  // 3 "_loggedIn" lets you check if the user has logged in.
  bool _loggedIn = false;
  // 4 "_onboardingComplete" checks if the user completed the onboarding flow.
  bool _onboardingComplete = false;
  // 5 "_selectedTab" keeps trach of which tab the user is on.
  int _selectedTab = FooderlichTab.explore;

  // 6 These are getter methods for each property. You cannot change these
  // properties outside AppStateManager. This is important for the
  // unidirectional flow architewcture, where you don't change state directly
  // but only via function calls or dispatched events.
  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isOnboardingComplete => _onboardingComplete;
  int get getSelectedTab => _selectedTab;

  void initializeApp() {
    // 7 Sets a delayed timer for 2,000 milliseconds before executing the
    // closure. This sets how long the splash screen will display after the user
    // launches the app. In a real app you would call the server to get feature
    // flags or app configurations. This simulates this scenario.
    Timer(
      const Duration(milliseconds: 2000),
      () {
        // 8 Sets "initialized" to true.
        _initialized = true;
        // 9 Notifies all listeners.
        notifyListeners();
      },
    );
  }

  void login(String username, String password) {
    // 10 Sets "loggedIn" to true.
    _loggedIn = true;
    // 11 Notifies all listeners.
    notifyListeners();
  }

  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  void goToTab(index) {
    _selectedTab = index;
    notifyListeners();
  }

  void goToRecipes() {
    _selectedTab = FooderlichTab.recipes;
    notifyListeners();
  }

  void logout() {
    // 12 Resets all app state properties.
    _loggedIn = false;
    _onboardingComplete = false;
    _initialized = false;
    _selectedTab = 0;

    // 13 Reinitializes the app.
    initializeApp();
    // 14 Notifies all listeners of state change.
    notifyListeners();
  }
}
