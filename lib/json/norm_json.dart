import 'dart:convert';

class JsonIsolate {
  static final JsonIsolate _singleton = JsonIsolate._internal();

  JsonIsolate._internal();

  factory JsonIsolate() {
    return _singleton;
  }

  Future<dynamic> decodeJson(String json) async {
    return jsonDecode(json);
  }

  Future<dynamic> encodeJson(dynamic toEncode) async {
    return jsonEncode(toEncode);
  }
}
