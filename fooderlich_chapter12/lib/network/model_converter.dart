import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'model_response.dart';
import 'recipe_model.dart';

// 1 Use "ModelConverter" to implement the Chopper "Converter" abstract class.
class ModelConverter implements Converter {
  // 2 Override "convertRequest()", which takes in a request and returns a new
  // request.
  @override
  Request convertRequest(Request request) {
    // 3 Add a header to the request that says you have a request type of
    // "application/json" using "jsonHeaders". These constants are part of
    // Chopper.
    final req = applyHeader(
      request,
      contentTypeKey,
      jsonHeaders,
      override: false,
    );

    // 4 Call "encodeJson()" to convert the request to a JSON-encoded one, as
    // required by the server API.
    return encodeJson(req);
  }

  Request encodeJson(Request request) {}

  Response decodeJson<BodyType, InnerType>(Response response) {}

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {}
}
