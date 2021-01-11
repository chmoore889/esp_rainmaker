import 'package:esp_rainmaker/esp_rainmaker.dart';
import 'package:esp_rainmaker/src/device_grouping/response_models.dart';
import 'package:esp_rainmaker/src/json/json.dart';
import 'package:esp_rainmaker/src/url_base.dart';
import 'package:http/http.dart';

/// Provides access to methods for managing device groupings.
class DeviceGrouping {
  final String accessToken;
  String _urlBase;

  static const String _devGroupBase = 'user/node_group';

  /// Contructs object to manage device groupings.
  ///
  /// Requires [accessToken] obtained from authentication.
  /// Uses the default API version of v1, though an
  /// alternative version can be specified.
  DeviceGrouping(this.accessToken, [APIVersion version = APIVersion.v1]) {
    _urlBase = URLBase.getBase(version);
  }

  /// Obtains details about user groups.
  ///
  /// Gets all groups if the [groupId] is
  /// not provided.
  Future<DeviceGroups> getGroup([String groupId]) async {
    final url = _urlBase +
        _devGroupBase +
        URLBase.getQueryParams({
          'group_id': groupId,
        });

    final resp = await get(url, headers: {
      URLBase.authHeader: accessToken,
    });
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return DeviceGroups.fromJson(bodyResp);
  }

  /// Creates a new user device group.
  ///
  /// Creates a new group with the available
  /// parameters and allows for metadata
  /// storage in the [type] parameter.
  Future<void> createGroup(String groupName,
      [String parentGroupId, String type, List<String> nodeIds]) async {
    final url = _urlBase + _devGroupBase;

    final body = await JsonIsolate().encodeJson({
      'group_name': groupName,
      'parent_group_id': parentGroupId,
      'type': type,
      'nodes': nodeIds,
    });

    final resp = await post(url, body: body, headers: {
      URLBase.authHeader: accessToken,
    });
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  /// Updates an existing user device group.
  ///
  /// Updates a group with the given
  /// parameters. When changing nodes, both
  /// the [operation] and [nodeIds] must be specified.
  Future<void> updateGroup(String groupId,
      {String groupName, OperationType operation, List<String> nodeIds}) async {
    final url = _urlBase +
        _devGroupBase +
        URLBase.getQueryParams({
          'group_id': groupId,
        });

    final body = await JsonIsolate().encodeJson({
      'group_name': groupName,
      'operation': operation.toShortString(),
      'nodes': nodeIds,
    });

    final resp = await put(url, body: body, headers: {
      URLBase.authHeader: accessToken,
    });
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  /// Deletes an existing user device group.
  ///
  /// Throws an exception if the group doesn't exist.
  Future<void> deleteGroup(String groupId) async {
    final url = _urlBase +
        _devGroupBase +
        URLBase.getQueryParams({
          'group_id': groupId,
        });

    final resp = await delete(url, headers: {
      URLBase.authHeader: accessToken,
    });
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }
}

enum OperationType {
  add,
  remove,
}

extension ParseOperationToString on OperationType {
  String toShortString() {
    return toString().split('.').last;
  }
}
