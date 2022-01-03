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
  static RecipeService create() {
    // 1 Create a "ChopperClient" instance.
    final client = ChopperClient(
      // 2 Pass in a base URL using the "apiUrl" constant.
      baseUrl: apiUrl,
      // 3 Pass in two interceptors. "_addQuery()" adds your key and ID to the
      // query. "HttpLoggingInterceptor" is part of Chopper and logs all calls.
      // It's handy while you're developing to see traffic between the app and
      // the server.
      interceptors: [_addQuery, HttpLoggingInterceptor()],
      // 4 Set the "converter" as an instance of "ModelConverter".
      converter: ModelConverter(),
      // 5 Use the built-in "JsonConverter" to decode any errors.
      errorConverter: const JsonConverter(),
      // 6 Define the services created when you run the generator script.
      services: [
        _$RecipeService(),
      ],
    );
    // 7 Return an instance of the generated service.
    return _$RecipeService(client);
  }
}

Request _addQuery(Request req) {
  // 1 Creates a "Map", which contains key-value pairs from the existing
  // "Request" parameters.
  final params = Map<String, dynamic>.from(req.parameters);
  // 2 Adds the "app_id" and the "app_key" parameters to the map.
  params['app_id'] = apiId;
  params['app_key'] = apiKey;
  // 3 Returns a new copy of the "Request" with the parameters contained in the
  // map.
  return req.copyWith(parameters: params);
}
