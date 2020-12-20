import 'dart:convert';

import 'package:esp_rainmaker/src/esp_rainmaker_base.dart';
import 'package:esp_rainmaker/src/url_base.dart';
import 'package:http/http.dart';

class NodeState {
  String _urlBase;

  static const String _nodeState = 'user/nodes/params';

  NodeState(APIVersion version) {
    _urlBase = URLBase.getBase(version);
  }

  Future<void> updateState(Map<String, dynamic> params) async {
    final url = _urlBase + _nodeState;

    final body = jsonEncode(params);
  
    final resp = await put(url, body: body);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  Future<Map<String, dynamic>> getState(String nodeId) async {
    final url = _urlBase + _nodeState + URLBase.getQueryParams({
      'nodeid': nodeId,
    });
  
    final resp = await get(url);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return bodyResp;
  }
}