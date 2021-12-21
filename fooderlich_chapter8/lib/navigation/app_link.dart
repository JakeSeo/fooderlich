class AppLink {
  // 1 Create constants for each URL path
  static const String homePath = '/home';
  static const String onboardingPath = '/onboarding';
  static const String loginPath = '/login';
  static const String profilePath = '/profile';
  static const String itemPath = '/item';
  // 2 Create constants for each of the query parameters you'll support.
  static const String tabParam = 'tab';
  static const String idParam = 'id';
  // 3 Store the path of the URL using "location".
  String? location;
  // 4 Use "currentTab" to store the tab you want to redirect the user to.
  int? currentTab;
  // 5 Store the ID of the item you want to view in "itemId".
  String? itemId;
  // 6 Initialize the app link with the location and the two query parameters.
  AppLink({
    this.location,
    this.currentTab,
    this.itemId,
  });

  static AppLink fromLocation(String? location) {
    // 1 First, you need to decode the URL. URLs are often perceont-decoded.
    // For example, you'd decode "%E4%B8%8A%E6%B5%B7" to "上海".
    // For more informationon URL encoding check out
    // https://developers.google.com/maps/url-encoding.
    location = Uri.decodeFull(location ?? '');
    // 2 Parse the URI for query parameter keys and key-value pairs.
    final uri = Uri.parse(location);
    final params = uri.queryParameters;

    // 3 Extract the "currentTab" from the URL path if it exists.
    final currentTab = int.tryParse(params[AppLink.tabParam] ?? '');
    // 4 Extract the "itemId" from the URL path if it exists.
    final itemId = params[AppLink.idParam];
    // 5 Create the "AppLink" by passing the query parameters you extract
    // from the URL.
    final link = AppLink(
      location: uri.path,
      currentTab: currentTab,
      itemId: itemId,
    );
    // 6 Return the instance of "AppLink".
    return link;
  }

  String toLocation() {
    // 1 Create an internal function that formats the query parameter key-value
    // pair into a string format.
    String addKeyValPair({
      required String key,
      String? value,
    }) =>
        value == null ? '' : '${key}=$value&';
    // 2 Go through each defined path.
    switch (location) {
      // 3 If the path is "loginPath", return the right string path: "/login".
      case loginPath:
        return loginPath;
      // 4 If the path is "onboardingPath", return the right string path: "/onboarding".
      case onboardingPath:
        return onboardingPath;
      // 5 If the path is "profilePath", return the right string path: "/profile".
      case profilePath:
        return profilePath;
      // 6 If the path is "itemPath", return the right string path: "/item",
      // and if there are any parameters, append "?id=${id}".
      case itemPath:
        var loc = '$itemPath?';
        loc += addKeyValPair(
          key: idParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      // 7 If thepath is invalid, default to the path "/home".
      // If the user selected a tab, append "?tab=${tabIndex}"
      default:
        var loc = '$homePath?';
        loc += addKeyValPair(
          key: tabParam,
          value: currentTab.toString(),
        );
        return Uri.encodeFull(loc);
    }
  }
}
