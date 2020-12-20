import 'dart:convert';

import 'package:esp_rainmaker/src/esp_rainmaker_base.dart';
import 'package:esp_rainmaker/src/nodes/response_models.dart';
import 'package:esp_rainmaker/src/url_base.dart';
import 'package:http/http.dart';

class NodeAssociation {
  String _urlBase;

  static const String _nodesBase = 'user/nodes';
  static const String _nodeConfig = _nodesBase + '/config';
  static const String _nodeMapping = _nodesBase + '/mapping';
  static const String _nodeStatus = _nodesBase + '/status';

  NodeAssociation(APIVersion version) {
    _urlBase = URLBase.getBase(version);
  }

  Future<NodesList> nodes({String nodeId, bool includeNodeDetails, String startId, String numRecords}) async {
    final url = _urlBase + _nodesBase + URLBase.getQueryParams({
      'node_id': nodeId,
      'node_details': includeNodeDetails,
      'start_id': startId,
      'num_records': numRecords,
    });
  
    final resp = await get(url);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return NodesList.fromJson(bodyResp);
  }

  Future<NodeConfig> nodeConfig(String nodeId) async {
    final url = _urlBase + _nodeConfig + URLBase.getQueryParams({
      'nodeid': nodeId,
    });
  
    final resp = await get(url);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return NodeConfig.fromJson(bodyResp);
  }

  Future<String> addNodeMapping(String nodeId, String secretKey) async {
    final url = _urlBase + _nodeMapping;

    final body = jsonEncode({
      'node_id': nodeId,
      'secret_key': secretKey,
      'operation': 'add',
    });
  
    final resp = await put(url, body: body);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return bodyResp['request_id'];
  }

  Future<void> removeNodeMapping(String nodeId) async {
    final url = _urlBase + _nodeMapping;

    final body = jsonEncode({
      'node_id': nodeId,
      'operation': 'remove',
    });
  
    final resp = await put(url, body: body);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  Future<MappingStatus> getMappingStatus(String requestId) async {
    final url = _urlBase + _nodeMapping + URLBase.getQueryParams({
      'request_id': requestId,
    });
  
    final resp = await get(url);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return MappingStatus.fromJson(bodyResp);
  }

  Future<NodeConnectivity> getNodeStatus(String nodeId) async {
    final url = _urlBase + _nodeStatus + URLBase.getQueryParams({
      'nodeid': nodeId,
    });
  
    final resp = await get(url);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return NodeConnectivity.fromJson(bodyResp['connectivity']);
  }
}