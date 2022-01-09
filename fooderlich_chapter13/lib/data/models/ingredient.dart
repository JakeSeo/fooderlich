import 'package:equatable/equatable.dart';

// 1 The "Ingredient" class extends "Equatable", to provide support for equality
// checks.
class Ingredient extends Equatable {
  // 2 Add the properties an ingredient needs. You don't declare "recipeId" or
  // "id" as "final" so you can change those values later.
  int? id;
  int? recipeId;
  final String? name;
  final double? weight;

  // 3 Declare a constructor with all the fields.
  Ingredient({this.id, this.recipeId, this.name, this.weight});

  // 4 When equality checks are performed, "Equatable" uses the "props" value.
  // Here, you provide the fields you want to use to check for equality.
  @override
  List<Object?> get props => [recipeId, name, weight];
}
