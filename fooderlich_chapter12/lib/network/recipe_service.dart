// 1 This adds the Chopper package and your models.
import 'package:chopper/chopper.dart';
import 'recipe_model.dart';
import 'model_response.dart';
import 'model_converter.dart';

// 2 Here is where you re-enter your API Key and ID.
const String apiKey = '5ef5d522d7ae9aca8e09b1d177945486';
const String apiId = '1445b02e';
// 3 The "/search" was removed from the URL so that you can call other APIs
// besides "/search".
const String apiUrl = 'https://api.edamam.com';

// 1 "@ChopperApi()" tells the Chopper generator to build a "part" file. This
// generated file will have the same name as this file, but with ".chopper"
// added to it. In this case, it will be "recipe_service.chopper.dart". Such a
// file will hold the boilderplate code.
@ChopperApi()
// 2 "RecipeService" is an "abstract" class because you only need to define the
// method signatures. The generator script will take these definitions and
// generate all the code needed.
abstract class RecipeService extends ChopperService {
  // 3 "@Get" is an annotation that tells the generator this is a "GET" request
  // with a "path" named "search", which you previously removed from the
  // "apiUrl". There are other HTTP methods you can use, such as "@Post", "@Put"
  // and "@Delete", but you won't use theme in this chapter.
  @Get(path: 'search')
  // 4 You define a function that returns a "Future" of a "Response" using the
  // previously created "APIRecipeQuery". The abstract "Result" that you created
  // above will hold either a value or an error.
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      // 5 "queryRecipes()" uses the Chopper "@Query" annotation to accept a
      // "query" string and "from" and "to" integers. This method doesn't have
      // a body. The generator script will created the body of this function
      // with all the parameters.
      @Query('q') String query,
      @Query('from') int from,
      @Query('to') int to);
  // TODO: Add create()
}
// TODO: Add _addQuery()
