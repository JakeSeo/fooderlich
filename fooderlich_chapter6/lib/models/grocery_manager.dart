import 'package:flutter/material.dart';
import 'grocery_item.dart';

class GroceryManager extends ChangeNotifier {
  // 1 This manager holds a private array of "_groceryItems". Only the manager
  // can change and update grocery items.
  final _groceryItems = <GroceryItem>[];

  // 2 Provides a public getter method for "groceryItems", which is unmodifiable
  // External entities can only read the list of grocery items.
  List<GroceryItem> get groceryItems => List.unmodifiable(_groceryItems);

  // 3 "deleteItem()" deletes an item at a particular index.
  void deleteItem(int index) {
    _groceryItems.removeAt(index);
    notifyListeners();
  }

  // 4 "addItem()" adds a new grocery item at the end of the list.
  void addItem(GroceryItem item) {
    _groceryItems.add(item);
    notifyListeners();
  }

  // 5 "updateItem()" replaces the old item at a given index with a new item.
  void updateItem(GroceryItem item, int index) {
    _groceryItems[index] = item;
    notifyListeners();
  }

  // 6 "completeItem()" toggles the "isComplete" flag on and off.
  void completeItem(int index, bool change) {
    final item = _groceryItems[index];
    _groceryItems[index] = item.copyWith(isComplete: change);
    notifyListeners();
  }
}
