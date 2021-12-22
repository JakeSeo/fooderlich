import 'package:http/http.dart';

const String apiKey = '5ef5d522d7ae9aca8e09b1d177945486';
const String apiId = '1445b02e';
const String apiUrl = 'https://api.edamam.com/search';

class RecipeService {
  // 1 "getData" returns a "Future" (with an upper case "F") because an API's
  // returned data type is determined in the future (lower case "f"). "async"
  // signifies this method is an asynchronous operation.
  Future getData(String url) async {
    // 2 For debugging purposes, you print out the passed-in URL.
    print('Calling url: $url');
    // 3 "response" doesn't have a value until "await" completes. "Response" and
    // "get()" are from the "HTTP" package. "get" fetches data from the provided
    // "url".
    final response = await get(Uri.parse(url));
    // 4 A "statusCode" of 200 means the request was successful.
    if (response.statusCode == 200) {
      // 5 You "return" the results embedded in response..body".
      return response.body;
    } else {
      // 6 Otherwise, you have an error - print the "statusCode" to the console.
      print(response.statusCode);
    }
  }

  // TODO: Add getRecipes
  // 1 Create a new method, "getRecipes()", with the parameters "query", "from",
  // and "to". These let you get specific pages from the complete query. "from"
  // starts at 0 and "to" is calculated by adding the "from" index to your page
  // size. You use type "Future<dynamic>" for this method because you don't know
  // which data type it will return or when it will finish. "async" signals that
  // this method runs asynchronously.
  Future<dynamic> getRecipes(String query, int from, int to) async {
    // 2
    final recipeData = await getData(
        '$apiUrl?app_id=$apiId&app_key=$apiKey&q=$query&from=$from&to=$to');
    // 3
    return recipeData;
  }
}
