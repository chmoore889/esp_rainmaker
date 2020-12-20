import 'dart:convert';

import 'package:esp_rainmaker/esp_rainmaker.dart';
import 'package:esp_rainmaker/src/url_base.dart';
import 'package:http/http.dart';

/// Provides access to methods for obtaining and updating node state.
class NodeState {
  String _urlBase;

  static const String _nodeState = 'user/nodes/params';

  /// Contructs object to access node state methods.
  ///
  /// Uses the default API version of v1, though an
  /// alternative version can be specified.
  NodeState([APIVersion version = APIVersion.v1]) {
    _urlBase = URLBase.getBase(version);
  }

  /// Updates the state of nodes with the given [params].
  ///
  /// Example map input:
  /// ```dart
  ///{
  ///  'Light': {
  ///    'brightness': 0,
  ///    'output': true,
  ///  },
  ///  'Switch': {
  ///    'output': true,
  ///  }
  ///}
  ///```
  Future<void> updateState(Map<String, dynamic> params) async {
    final url = _urlBase + _nodeState;

    final body = jsonEncode(params);

    final resp = await put(url, body: body);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  /// Obtains the state of the node with id [nodeId].
  ///
  /// Example map output:
  /// ```dart
  ///{
  ///  'Light': {
  ///    'brightness': 0,
  ///    'output': true,
  ///  },
  ///  'Switch': {
  ///    'output': true,
  ///  }
  ///}
  ///```
  Future<Map<String, dynamic>> getState(String nodeId) async {
    final url = _urlBase +
        _nodeState +
        URLBase.getQueryParams({
          'nodeid': nodeId,
        });

    final resp = await get(url);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return bodyResp;
  }
}
