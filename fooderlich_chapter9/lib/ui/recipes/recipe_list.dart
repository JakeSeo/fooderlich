import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_dropdown.dart';
import '../colors.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  static const String prefSearchKey = 'previousSearches';

  late TextEditingController searchTextController;
  final ScrollController _scrollController = ScrollController();
  List currentSearchList = [];
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 20;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  List<String> previousSearches = <String>[];

  @override
  void initState() {
    super.initState();
    getPreviousSearches();

    searchTextController = TextEditingController(text: '');
    _scrollController
      ..addListener(() {
        final triggerFetchMoreSize =
            0.7 * _scrollController.position.maxScrollExtent;

        if (_scrollController.position.pixels > triggerFetchMoreSize) {
          if (hasMore &&
              currentEndPosition < currentCount &&
              !loading &&
              !inErrorState) {
            setState(() {
              loading = true;
              currentStartPosition = currentEndPosition;
              currentEndPosition =
                  min(currentStartPosition + pageCount, currentCount);
            });
          }
        }
      });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void savePreviousSearches() async {
    // 1 Uses the "await" keyword to wait for an instance of "SharedPreferences"
    final prefs = await SharedPreferences.getInstance();
    // 2 Saves the list of previous searches using the "prefSearchKey" key.
    prefs.setStringList(prefSearchKey, previousSearches);
  }

  void getPreviousSearches() async {
    // 1 Use the "await" keyword to wait for an instance of "SharedPreferences".
    final prefs = await SharedPreferences.getInstance();
    // 2 Check if a preferences for your saved list already exists.
    if (prefs.containsKey(prefSearchKey)) {
      // 3 Get the list of previous searches.
      final searches = prefs.getStringList(prefSearchKey);
      // 4 If the list is not "null", set the previous searches,
      // otherwise initialize an empty list.
      if (searches != null) {
        previousSearches = searches;
      } else {
        previousSearches = <String>[];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildSearchCard(),
            _buildRecipeLoader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              // 1 Add "onPressed" to handle the tap event.
              onPressed: () {
                // 2 Use the current search text to start a search.
                startSearch(searchTextController.text);
                // 3 Hide the keyboard by using the "FocusScope" class.
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
            ),
            const SizedBox(
              width: 6.0,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                      // 3 Add a "TextField" to enter your search queries.
                      child: TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Search'),
                    autofocus: false,
                    // 4 Set the keyboard action to "TextInputAction.done".
                    // This closes the keyboard when the user presses the Done
                    // button.
                    textInputAction: TextInputAction.done,
                    // 5 Save the search when the user finishes entering text.
                    onSubmitted: (value) {
                      if (!previousSearches.contains(value)) {
                        previousSearches.add(value);
                        savePreviousSearches();
                      }
                    },
                    controller: searchTextController,
                  )),
                  // 6 Create a "PopupMenuButton" to show previous searches.
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: lightGrey,
                    ),
                    // 7 When the user selects an item from previous searches,
                    // start a new search.
                    onSelected: (String value) {
                      searchTextController.text = value;
                      startSearch(searchTextController.text);
                    },
                    itemBuilder: (BuildContext context) {
                      // 8 Build a list of custom drop-down menus
                      // (see "widgets/custom_dropdown.dart") to display
                      // previous searches.
                      return previousSearches
                          .map<CustomDropdownMenuItem<String>>((String value) {
                        return CustomDropdownMenuItem<String>(
                          text: value,
                          value: value,
                          callback: () {
                            setState(() {
                              // 9 If the "X" icon is pressed, remove the search
                              // from the previous searches and close the
                              // pop-up menu.
                              previousSearches.remove(value);
                              Navigator.pop(context);
                            });
                          },
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startSearch(String value) {
    // 1 Tell the system to redraw the widgets by calling "setState()".
    setState(() {
      // 2 Clear the current search list and reset the count,
      // start and end positions.
      currentSearchList.clear();
      currentCount = 0;
      currentEndPosition = pageCount;
      currentStartPosition = 0;
      hasMore = true;
      value = value.trim();

      // 3 Check to make sure the search text hasn't already been added to the
      // previous search list.
      if (!previousSearches.contains(value)) {
        // 4 Add the search item to the previous search list.
        previousSearches.add(value);
        // 5 Save the new list of previous searches.
        savePreviousSearches();
      }
    });
  }

  Widget _buildRecipeLoader(BuildContext context) {
    if (searchTextController.text.length < 3) {
      return Container();
    }
    // Show a loading indicator while waiting for the movies
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
