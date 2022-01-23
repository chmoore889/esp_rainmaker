import 'package:meta/meta.dart';

/// List of node IDs and node data if requested.
@immutable
class NodesList {
  /// List of node IDs.
  final List<String> nodeIds;

  ///List of node details if requested.
  final List<NodeDetails> nodeDetails;

  /// The next node ID.
  final String? nextId;

  /// The total number of nodes.
  final int? totalNodes;

  const NodesList({
    required this.nodeIds,
    required this.nodeDetails,
    required this.nextId,
    required this.totalNodes,
  });

  factory NodesList.fromJson(Map<String, dynamic> json) {
    return NodesList(
      nodeIds: [...(json['nodes'] ?? []).cast<String>()],
      nodeDetails: [
        ...(json['node_details'] ?? [])
            .map<NodeDetails>(
                (nodeDetails) => NodeDetails.fromJson(nodeDetails))
            .toList()
      ],
      nextId: json['next_id'],
      totalNodes: json['total'],
    );
  }

  @override
  String toString() {
    return 'NodesList(Node Ids: $nodeIds, Node Details: $nodeDetails, Next Id: $nextId, Total Nodes: $totalNodes)';
  }
}

/// Detailed information related to a node.
@immutable
class NodeDetails {
  /// The node's ID.
  final String id;

  /// The connectivity status of the node.
  final NodeConnectivity status;

  /// Configuration data related to the node.
  final NodeConfig config;

  /// Key-value pairs of the parameters associated with a node.
  final Map<String, dynamic> params;

  const NodeDetails({
    required this.id,
    required this.status,
    required this.config,
    required this.params,
  });

  factory NodeDetails.fromJson(Map<String, dynamic> json) {
    return NodeDetails(
      id: json['id'],
      status: NodeConnectivity.fromJson(json['status']['connectivity']),
      config: NodeConfig.fromJson(json['config']),
      params: json['params'],
    );
  }

  @override
  String toString() {
    return 'NodeDetails(Node Id: $id, Connectivity Status: $status, Config: $config, Node Params: $params)';
  }
}

/// Connectivity information related to a node.
@immutable
class NodeConnectivity {
  /// Connectivity status of a node.
  final bool isConnected;

  /// Last time at which a node was connected.
  final int timestamp;

  const NodeConnectivity({
    required this.isConnected,
    required this.timestamp,
  });

  factory NodeConnectivity.fromJson(Map<String, dynamic> json) {
    return NodeConnectivity(
      isConnected: json['connected'],
      timestamp: json['timestamp'],
    );
  }

  @override
  String toString() {
    return 'NodeConnectivity(Is Connected: $isConnected, Timestamp: $timestamp)';
  }
}

/// Configuration information related to a node.
@immutable
class NodeConfig {
  /// The node's ID.
  final String id;
  final String configVersion;

  /// The version of firmware running on the node.
  final String firmwareVersion;

  /// The name of the node.
  final String name;

  /// The type of the node.
  final String type;

  /// Key-value pairs of the parameters associated with a node.
  final List<Map<String, dynamic>> devices;

  const NodeConfig({
    required this.id,
    required this.configVersion,
    required this.firmwareVersion,
    required this.name,
    required this.type,
    required this.devices,
  });

  factory NodeConfig.fromJson(Map<String, dynamic> json) {
    return NodeConfig(
      id: json['node_id'],
      configVersion: json['config_version'],
      firmwareVersion: json['info']['fw_version'],
      name: json['info']['name'],
      type: json['info']['type'],
      devices: json['devices']?.cast<Map<String, dynamic>>(),
    );
  }

  @override
  String toString() {
    return 'NodeConfig(Id: $id, ConfigVer: $configVersion, FWVer: $firmwareVersion, Name: $name, Type: $type, Devices: $devices)';
  }
}

/// The status of a mapping operation.
@immutable
class MappingStatus {
  /// The ID of the node being mapped.
  final String? nodeId;
  final String? timestamp;

  /// The current status of the mapping request.
  final MappingRequestStatus status;
  final String? confirmTimestamp;
  final String? discardedTimestamp;

  /// The source of the mapping request.
  final MappingRequestSource? source;

  /// The mapping request ID.
  final String? requestId;

  const MappingStatus({
    required this.nodeId,
    required this.timestamp,
    required this.status,
    required this.confirmTimestamp,
    required this.discardedTimestamp,
    required this.source,
    required this.requestId,
  });

  factory MappingStatus.fromJson(Map<String, dynamic> json) {
    MappingRequestStatus enumFromString(
        List<MappingRequestStatus> enumList, String value) {
      return enumList.firstWhere(
        (type) => type.name == value,
      );
    }

    T? enumFromStringNull<T>(List<T> enumList, String? value) {
      if (value == null) return null;
      return enumList.firstWhere(
        (type) => type.toString().split('.').last == value,
      );
    }

    print(json);
    return MappingStatus(
      nodeId: json['user_node_id'],
      timestamp: json['request_timestamp'],
      status:
          enumFromString(MappingRequestStatus.values, json['request_status']),
      confirmTimestamp: json['confirm_timestamp'],
      discardedTimestamp: json['discarded_timestamp'],
      source: enumFromStringNull(
          MappingRequestSource.values, json['request_source']),
      requestId: json['request_id'],
    );
  }
}

/// Details of who a node is shared with.
@immutable
class SharingDetail {
  /// The ID of the node in question.
  final String nodeId;

  /// The primary users associated with the node.
  final List<String> primaryUsers;

  /// The secondary users associated with the node.
  final List<String> secondaryUsers;

  const SharingDetail({
    required this.nodeId,
    required this.primaryUsers,
    required this.secondaryUsers,
  });

  factory SharingDetail.fromJson(Map<String, dynamic> json) {
    return SharingDetail(
      nodeId: json['node_id'],
      primaryUsers: json['users']['primary']?.cast<String>() ?? [],
      secondaryUsers: json['users']['secondary']?.cast<String>() ?? [],
    );
  }

  @override
  String toString() {
    return 'SharingDetail(nodeId: $nodeId, primaryUsers: $primaryUsers, secondaryUsers: $secondaryUsers)';
  }
}

/// Possible statuses for a mapping request.
enum MappingRequestStatus {
  requested,
  confirmed,
  timedout,
  discarded,
}

/// Possible sources for a mapping request.
enum MappingRequestSource { user, node }
