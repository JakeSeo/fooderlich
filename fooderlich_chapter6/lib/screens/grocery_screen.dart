import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import 'empty_grocery_screen.dart';
import 'grocery_item_screen.dart';
import 'grocery_list_screen.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 5 The main layout structure for "GroceryScreen" is a scaffold.
    return Scaffold(
      // 6 Adds a floating action button with a + icon.
      // Tapping the button presents the screen to create or add an item.
      // You'll build this screen later.
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // 1 Returns the "GroceryManager" available in the tree.
          final manager = Provider.of<GroceryManager>(context, listen: false);
          // 2 "Navigator.push()" adds a new route to the stack of routes.
          Navigator.push(
            context,
            // 3 "MaterialPageRoute" replaces the entire screen with a
            // platform-specific transition. In Android, for example, it
            // slides upwards and fades in. In iOS, it slides in from the right.
            MaterialPageRoute(
              // 4 Creates a new "GroceryItemScreen" within the route's
              // builder callback.
              builder: (context) => GroceryItemScreen(
                // 5 "onCreate" defines what to do with the created item.
                onCreate: (item) {
                  // 6 "addItem()" adds this new item to the list of items.
                  manager.addItem(item);
                  // 7 Once the item is added to the list, "pop" removes the
                  // top navigation route item, "GroceryItemScreen",
                  // to show the list of grocery items.
                  Navigator.pop(context);
                },
                // 8 "onUpdate" will never get called since you are creating
                // a new item.
                onUpdate: (item) {},
              ),
            ),
          );
        },
      ),
      // 7 Builds the rest of the Grocery screen's subtree.
      // That's coming up next!
      body: buildGroceryScreen(),
    );
  }

  Widget buildGroceryScreen() {
    // 1 You wrap your widgets inside a "Consumer", which listens for
    // "GroceryManager" state changes.
    return Consumer<GroceryManager>(
      // 2 "Consumer" rebuilds the widgets below itself when the grocery manager
      // items changes.
      builder: (context, manager, child) {
        // 3 If there are grocery items in the list, show the
        // "GroceryListScreen". You will create this screen soon.
        if (manager.groceryItems.isNotEmpty) {
          return GroceryListScreen(manager: manager);
        } else {
          // 4 Ifthere are no grocery items, show the "EmptyGroceryScreen".
          return const EmptyGroceryScreen();
        }
      },
    );
  }
}
