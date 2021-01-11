import 'package:esp_rainmaker/esp_rainmaker.dart';
import 'package:esp_rainmaker/src/isolate_json.dart';
import 'package:esp_rainmaker/src/nodes/response_models.dart';
import 'package:esp_rainmaker/src/url_base.dart';
import 'package:http/http.dart';

/// Provides access to methods for associating a node with a user.
class NodeAssociation {
  final String accessToken;
  String _urlBase;

  static const String _nodesBase = 'user/nodes';
  static const String _nodeConfig = _nodesBase + '/config';
  static const String _nodeMapping = _nodesBase + '/mapping';
  static const String _nodeStatus = _nodesBase + '/status';
  static const String _nodeSharing = _nodesBase + '/sharing';

  /// Contructs object to access node association methods.
  ///
  /// Requires [accessToken] obtained from authentication.
  /// Uses the default API version of v1, though an
  /// alternative version can be specified.
  NodeAssociation(this.accessToken, [APIVersion version = APIVersion.v1]) {
    _urlBase = URLBase.getBase(version);
  }

  /// Gets the nodes associated with the user
  ///
  /// Can optionally include node details by setting [includeNodeDetails]
  /// true. Will throw an exception when there is a failure containing
  /// a description of the failure.
  Future<NodesList> nodes(
      {String nodeId,
      bool includeNodeDetails = false,
      String startId,
      int numRecords}) async {
    final url = _urlBase +
        _nodesBase +
        URLBase.getQueryParams({
          'node_id': nodeId,
          'node_details': includeNodeDetails.toString(),
          'start_id': startId,
          'num_records': numRecords,
        });

    final resp = await get(
      url,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return NodesList.fromJson(bodyResp);
  }

  /// Gets the configuration of a single node.
  ///
  /// Will throw an exception when there is a failure containing a
  /// description of the failure.
  Future<NodeConfig> nodeConfig(String nodeId) async {
    final url = _urlBase +
        _nodeConfig +
        URLBase.getQueryParams({
          'nodeid': nodeId,
        });

    final resp = await get(
      url,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return NodeConfig.fromJson(bodyResp);
  }

  /// Adds a user node mapping and returns the **request id**.
  ///
  /// Will throw an exception when there is a failure containing a
  /// description of the failure.
  Future<String> addNodeMapping(String nodeId, String secretKey) async {
    final url = _urlBase + _nodeMapping;

    final body = await JsonIsolate().encodeJson({
      'node_id': nodeId,
      'secret_key': secretKey,
      'operation': 'add',
    });

    final resp = await put(
      url,
      body: body,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return bodyResp['request_id'];
  }

  /// Removes a user node mapping.
  ///
  /// Will throw an exception when there is a failure containing a
  /// description of the failure.
  Future<void> removeNodeMapping(String nodeId) async {
    final url = _urlBase + _nodeMapping;

    final body = await JsonIsolate().encodeJson({
      'node_id': nodeId,
      'operation': 'remove',
    });

    final resp = await put(
      url,
      body: body,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  /// Gets the status of User Node mapping request.
  ///
  /// Will throw an exception when there is a failure containing a
  /// description of the failure.
  Future<MappingStatus> getMappingStatus(String requestId) async {
    final url = _urlBase +
        _nodeMapping +
        URLBase.getQueryParams({
          'request_id': requestId,
        });

    final resp = await get(
      url,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return MappingStatus.fromJson(bodyResp);
  }

  /// Get the connectivity status for the node.
  ///
  /// Will throw an exception when there is a failure containing a
  /// description of the failure.
  Future<NodeConnectivity> getNodeStatus(String nodeId) async {
    final url = _urlBase +
        _nodeStatus +
        URLBase.getQueryParams({
          'nodeid': nodeId,
        });

    final resp = await get(
      url,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return NodeConnectivity.fromJson(bodyResp['connectivity']);
  }

  /// Shares nodes with another user.
  ///
  /// Takes list of node ids to share and
  /// a single email to share them with.
  Future<void> share(List<String> nodeIds, String email) async {
    final url = _urlBase + _nodeSharing;

    final body = await JsonIsolate().encodeJson({
      'node_id': nodeIds,
      'email': email,
    });

    final resp = await put(
      url,
      body: body,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  /// Unshares nodes with another user.
  ///
  /// Takes list of node ids to share and
  /// a single email to share them with.
  Future<void> unshare(List<String> nodeIds, String email) async {
    final url = _urlBase +
        _nodeSharing +
        URLBase.getQueryParams({
          'nodes': nodeIds,
          'email': email,
        });

    final resp = await delete(
      url,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  /// Obtains who a node is shared with.
  ///
  /// Takes the id of the node and returns
  /// who it's shared with.
  Future<SharingDetail> getShare(String nodeId) async {
    final url = _urlBase +
        _nodeSharing +
        URLBase.getQueryParams({
          'node_id': nodeId,
        });

    final resp = await delete(
      url,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return SharingDetail.fromJson(bodyResp);
  }
}
