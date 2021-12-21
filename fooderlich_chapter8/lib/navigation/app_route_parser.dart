import 'package:flutter/material.dart';

import 'app_link.dart';

// 1 "AppRouteParser" extends "RouteInformationParser". Notice it takes a
// generic type. In this case, your type is AppLink", which holds all the route
// and navigation information.
class AppRouteParser extends RouteInformationParser<AppLink> {
  // 2 The first method you need to override is "parserRouteInformation()".
  // The route information contains the URL string.
  @override
  Future<AppLink> parseRouteInformation(
      RouteInformation routeInformation) async {
    // 3 Take the route information and build an instance of "AppLink" from it.
    final link = AppLink.fromLocation(routeInformation.location);
    return link;
  }

  // 4 The second method you need to override is "restoreRouteInformation()".
  @override
  RouteInformation restoreRouteInformation(AppLink appLink) {
    // 5 This function passes in an "ApLink" object. You ask "AppLink" to give
    // you back the URL string.
    final location = appLink.toLocation();
    // 6 You wrap it in "RouteInformation" to pass it along.
    return RouteInformation(location: location);
  }
}
