import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/screens.dart';

// 1 It extends "RouterDelegate". The system will tell the router to build and
// configure a navigatore widget.
class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  // 2 Declares "GlobalKey", a unique key across the entier app.
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  // 3 Declares "AppStateManager". The router will listen to app state changes
  // to configure the navigator's list of pages.
  final AppStateManager appStateManager;
  // 4 Declares "GroceryManager" to listen to the user's state when you create
  // or edit an item.
  final GroceryManager groceryManager;
  // 5 Declares "ProfileManager" to listen to the user profile state.
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    // "appStateManager": Determines the state of the app. It manages whether
    // the app initialized login and if the user completed the onboarding.
    appStateManager.addListener(notifyListeners);
    // "groceryManager": Manages the list of grocery items and the
    // item selection state.
    groceryManager.addListener(notifyListeners);
    // "profileManager": Manages the user's profile and settings.
    profileManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  // 6 "RouterDelegate" requires you to add a "build()". This configures your
  // navigator and pages.
  @override
  Widget build(BuildContext context) {
    // 7 Configures a "Navigator".
    return Navigator(
      // 8 Uses the "navigatorKey", which is required to retrieve the current
      // navigator.
      key: navigatorKey,
      onPopPage: _handlePopPage,
      // 9 Declares "pages", the stack of pages that describes your navigation
      // stack.
      pages: [
        if (!appStateManager.isInitialized) SplashScreen.page(),
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
          OnboardingScreen.page(),
        if (appStateManager.isOnboardingComplete)
          Home.page(appStateManager.getSelectedTab),
        // 1 Checks if the user is creating a new grocery item.
        if (groceryManager.isCreatingNewItem)
          // 2 If so, shows the Grocery Item screen.
          GroceryItemScreen.page(
            onCreate: (item) {
              // 3 Once the user saves the item, updates the grocery list.
              groceryManager.addItem(item);
            },
            onUpdate: (item, index) {
              // 4 No update
              // "onUpdate" only gets called when the user updates an existing
              //  item.
            },
          ),
        // 1 Checks to see if a grocery item is selected
        if (groceryManager.selectedIndex != -1)
          // 2 If so, creates the Grocery Item screen page
          GroceryItemScreen.page(
              item: groceryManager.selectedGroceryItem,
              index: groceryManager.selectedIndex,
              onUpdate: (item, index) {
                // 3 When the user changes and saves an item, it updates the
                // item at the current index.
                groceryManager.updateItem(item, index);
              },
              onCreate: (_) {
                // 4 No create
                // "onCreate" only gets called when the user adds a new item.
              }),
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),
        if (profileManager.didTapOnRaywenderlich) WebViewScreen.page(),
      ],
    );
  }

  bool _handlePopPage(
      // 1 This is the current "Route", which contains information like
      // "RouteSettings" to retrieve the route's name and arguments.
      Route<dynamic> route,
      // 2 "result" is the value that returns when the route completes -
      // a value that a dialog returns, for example.
      result) {
    // 3 Checks if the current route's pop succeeded.
    if (!route.didPop(result)) {
      // 4 If it failed, return "false".
      return false;
    }

    // 5 If the route pop succeeds, this checks the different routes and
    // triggers the appropriate state changes.
    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }
    if (route.settings.name == FooderlichPages.groceryItemDetails) {
      groceryManager.groceryItemTapped(-1);
    }
    if (route.settings.name == FooderlichPages.profilePath) {
      profileManager.tapOnProfile(false);
    }
    if (route.settings.name == FooderlichPages.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }

    return true;
  }

  // 10 Sets "setNewRoutePath" to "null" since you aren't supporting
  // Flutter web apps yet. Don't worry about that for now, you'll learn
  // more about that topic int he next chapter.
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
