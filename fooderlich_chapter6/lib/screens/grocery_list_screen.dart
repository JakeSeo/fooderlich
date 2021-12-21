import 'package:flutter/material.dart';
import '../components/grocery_tile.dart';
import '../models/models.dart';
import 'grocery_item_screen.dart';

class GroceryListScreen extends StatelessWidget {
  final GroceryManager manager;

  const GroceryListScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1 Get the list of grocery items from the manager.
    final groceryItems = manager.groceryItems;
    // 2 Apply padding of 16 pixels all around this screen.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      // 3 Add "ListView".
      child: ListView.separated(
        // 4 Set the number of items in the list.
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final item = groceryItems[index];
          //// 1 You wrap "GroceryTile" inside an "InkWell".
          return Dismissible(
            // 6 The dismissible widget includes a "Key". Flutter needs this to
            // find and remove the right element in the tree.
            key: Key(item.id),
            // 7 Sets the direction the user can swipe to dismiss
            direction: DismissDirection.endToStart,
            // 8 Selects the background widget to display behind the widget
            // you're swiping. In this case, the background widget is red with
            // a white trash can "Icon" aligned in the center and to the right
            // of the "Container".
            background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete_forever,
                    color: Colors.white, size: 50.0)),
            // 9 "onDismissed" lets you know when the user swiped away a
            // "GroceryTile".
            onDismissed: (direction) {
              // 10 Lets the grocery manager handle deleting the item, given an
              // index.
              manager.deleteItem(index);
              // 11 Shows a snack bar widget to let the user know which item
              // they deleted.
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} dismissed')));
            },
            child: InkWell(
              child: GroceryTile(
                  key: Key(item.id),
                  item: item,
                  onComplete: (change) {
                    if (change != null) {
                      manager.completeItem(index, change);
                    }
                  }),
              // 2 When the gesture recognizes a tap, it presents
              // "GroceryItemScreen", letting the user edit the current item.
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroceryItemScreen(
                      originalItem: item,
                      // 3 "GroceryItemScreen" calls "onUpdate" when
                      // the user updates an item.
                      onUpdate: (item) {
                        // 4 "GroceryManager" updates the item at the particular
                        // index.
                        manager.updateItem(item, index);
                        // 5 Dismisses "GroceryItemScreen".
                        Navigator.pop(context);
                      },
                      // 6 "onCreate" will not be called since you are updating
                      // an existing item.
                      onCreate: (item) {},
                    ),
                  ),
                );
              },
            ),
          );
        },
        // 8 Space each grocery item 16 pixels apart.
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}
