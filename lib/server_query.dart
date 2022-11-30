import 'dart:convert';

import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:wera_f2/get_controller.dart';
import 'package:wera_f2/strings.dart';

enum RequestType {
  get,
  post,
  patch,
  put,
  delete,
}

Future<Map> query({
  required String link,
  required RequestType type,
  Map<String, dynamic>? params,
  String? backend,
}) async {
  try {
    final GlobalController global = Get.find();
    String requestLink = _addParams(link: link, params: params);

    if (backend != null) {
      requestLink = backend + requestLink;
    } else {
      requestLink = global.backend! + requestLink;
    }

    Response response = await _getCorrectResponse(
      link: requestLink,
      type: type,
      token: global.token,
    );

    Map data = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      if (data["data"] != null) {
        return _output(true, message: data["message"], data: data["data"]);
      }

      return _output(true, message: data["message"]);
    } else {
      return _output(false, message: data["message"]);
    }
  } catch (e) {
    return _output(false, message: PStrings.noConnection);
  }
}

Map _output(bool success, {String? message, data}) {
  return {
    "success": success,
    "message": message,
    "data": data,
  };
}

String _addParams({required String link, Map<String, dynamic>? params}) {
  link = "$link/";

  if (params != null) {
    List<String> keys = params.keys.toList();

    for (int i = 0; i < params.length; i++) {
      if (i == 0) {
        link += "?${keys[i]}=${params[keys[i]]}";
      } else {
        link += "&${keys[i]}=${params[keys[i]]}";
      }
    }
  }

  return link;
}

Future<Response> _getCorrectResponse({
  required String link,
  required RequestType type,
  String? token,
}) async {
  
  Map<String, String> auth = {'Authorization': 'Bearer $token'};
  Uri uri = Uri.parse(link);

  switch (type) {
    case RequestType.post: return await post(uri, headers: auth);
    case RequestType.get: return await get(uri, headers: auth);
    case RequestType.delete: return await delete(uri, headers: auth);
    case RequestType.patch: return await patch(uri, headers: auth);
    case RequestType.put: return await put(uri, headers: auth);
  }
}
