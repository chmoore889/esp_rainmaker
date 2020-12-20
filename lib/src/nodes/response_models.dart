import 'package:meta/meta.dart';

@immutable
class NodesList {
  final List<String> nodeIds;
  final List<NodeDetails> nodeDetails;
  final String nextId;
  final int totalNodes;

  NodesList({
    @required this.nodeIds,
    @required this.nodeDetails,
    @required this.nextId,
    @required this.totalNodes,
  });

  factory NodesList.fromJson(Map<String, dynamic> json) {
    List<String> parseNodeIds(String nodeIds) {
      final trimmed = nodeIds.substring(1, nodeIds.length - 1);
      return trimmed.split(', ');
    }
    
    return NodesList(
      nodeIds: parseNodeIds(json['nodes']),
      nodeDetails: (json['accesstoken'] as List).map<NodeDetails>((nodeDetails) => NodeDetails.fromJson(nodeDetails)),
      nextId: json['refreshtoken'],
      totalNodes: json['refreshtoken'],
    );
  }
}

@immutable
class NodeDetails {
  final String id;
  final NodeConnectivity status;
  final NodeConfig config;
  final Map<String, dynamic> params;

  NodeDetails({
    @required this.id,
    @required this.status,
    @required this.config,
    @required this.params,
  });

  factory NodeDetails.fromJson(Map<String, dynamic> json) {
    return NodeDetails(
      id: json['id'],
      status: NodeConnectivity.fromJson(json['status']['connectivity']),
      config: NodeConfig.fromJson(json['config']),
      params: json['params'],
    );
  }
}

@immutable
class NodeConnectivity {
  final bool isConnected;
  final int timestamp;

  NodeConnectivity({
    this.isConnected,
    this.timestamp,
  });

  factory NodeConnectivity.fromJson(Map<String, dynamic> json) {
    return NodeConnectivity(
      isConnected: json['connected'],
      timestamp: json['timestamp'],
    );
  }
}

@immutable
class NodeConfig {
  final String id;
  final String configVersion;
  final String firmwareVersion;
  final String name;
  final String type;
  final List<Map<String, dynamic>> devices;

  NodeConfig({
    @required this.id,
    @required this.configVersion,
    @required this.firmwareVersion,
    @required this.name,
    @required this.type,
    @required this.devices,
  });

  factory NodeConfig.fromJson(Map<String, dynamic> json) {
    return NodeConfig(
      id: json['node_id'],
      configVersion: json['config_version'],
      firmwareVersion: json['info']['fw_version'],
      name: json['info']['name'],
      type: json['info']['type'],
      devices: json['devices'],
    );
  }
}

@immutable
class MappingStatus {
  final String nodeId;
  final String timestamp;
  final MappingRequestStatus status;
  final String confirmTimestamp;
  final String discardedTimestamp;
  final MappingRequestSource source;
  final String requestId;

  MappingStatus({
    @required this.nodeId,
    @required this.timestamp,
    @required this.status,
    @required this.confirmTimestamp,
    @required this.discardedTimestamp,
    @required this.source,
    @required this.requestId,
  });

  factory MappingStatus.fromJson(Map<String, dynamic> json) {
    T enumFromString<T>(List<T> enumList, String value) {
      return enumList.firstWhere(
        (type) => type.toString().split('.').last == value,
      );
    }

    return MappingStatus(
      nodeId: json['user_node_id'],
      timestamp: json['request_timestamp'],
      status: enumFromString(MappingRequestStatus.values, json['request_status']),
      confirmTimestamp: json['confirm_timestamp'],
      discardedTimestamp: json['discarded_timestamp'],
      source: enumFromString(MappingRequestSource.values, json['request_source']),
      requestId: json['request_id'],
    );
  }
}

enum MappingRequestStatus {
  requested,
  confirmed,
  timedout,
  discarded,
}

enum MappingRequestSource {
  user,
  node
}