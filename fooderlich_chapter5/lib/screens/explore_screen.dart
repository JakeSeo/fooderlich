import 'package:flutter/material.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../api/mock_fooderlich_service.dart';

class ExploreScreen extends StatefulWidget {
  // 1 Create a "MockFooderlichService", to mock server responses.

  ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final mockService = MockFooderlichService();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(scrollListener);
  }

  void scrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      print('i am at the bottom!');
    } else if (_scrollController.offset ==
        _scrollController.position.minScrollExtent) {
      print('i am at the top!');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1 This is the "FutureBuilder" from before. It runs an asynchronous task
    // and lets you know the state of the future.
    return FutureBuilder(
      // 2 Use your mock service to call "getExploreData()". This returns an
      // "ExploreData" object future.
      future: mockService.getExploreData(),
      // 3 Check the state of the future within the "builder" callback.
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        // 4 Check if the future is complete.
        if (snapshot.connectionState == ConnectionState.done) {
          // 5 When the future is complete, return the primary "ListView". This
          // holds an explicit list of children. In this scenario, the primary
          // "ListView" will hold the other two "ListView"s as children.
          return ListView(
            // 6 Set the scroll direction to vertical, although that's the
            // default value.
            scrollDirection: Axis.vertical,
            children: [
              // 7 The first item in "children" is "TodayRecipeListView".
              // You pass in the list of "todayRecipes" from "ExploreData".
              TodayRecipeListView(recipes: snapshot.data?.todayRecipes ?? []),
              // 8 Add a 16-point vertical space so the lists aren't too close
              // to each other.
              const SizedBox(height: 16),
              // 9 Add a green placeholder container. You'll create and add the
              // "FriendPostListView" later.
              FriendPostListView(friendPosts: snapshot.data?.friendPosts ?? []),
            ],
            controller: _scrollController,
          );
        } else {
          // 10 If the future hasn't finished loading yet, show a
          // circular progress indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
