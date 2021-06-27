import 'package:meta/meta.dart';

/// List of device groups.
@immutable
class DeviceGroups {
  /// List of device groups.
  final List<DeviceGroup>? deviceGroups;

  /// The total number of records.
  final int? total;

  const DeviceGroups({
    this.deviceGroups,
    this.total,
  });

  factory DeviceGroups.fromJson(Map<String, dynamic> json) {
    return DeviceGroups(
      deviceGroups: (json['groups'] as List?)
          ?.map<DeviceGroup>((e) => DeviceGroup.fromJson(e))
          .toList(),
      total: json['total'],
    );
  }

  @override
  String toString() {
    return 'DeviceGroups(deviceGroups: $deviceGroups, total: $total)';
  }
}

@immutable
class DeviceGroup {
  /// Name of the group.
  final String? name;

  /// Id of the group.
  final String? id;

  /// Type of the group
  final String? type;

  /// List of node ids in the group
  final List<String>? nodes;

  /// List of subgroups if any
  final List<DeviceGroup>? subgroups;

  const DeviceGroup({
    this.id,
    this.name,
    this.nodes,
    this.subgroups,
    this.type,
  });

  factory DeviceGroup.fromJson(Map<String, dynamic> json) {
    return DeviceGroup(
      id: json['group_id'],
      name: json['group_name'],
      nodes: json['nodes'].cast<String>(),
      subgroups: (json['sub_groups'] as List?)
          ?.map<DeviceGroup>((e) => DeviceGroup.fromJson(e))
          .toList(),
      type: json['type'],
    );
  }

  @override
  String toString() {
    return 'DeviceGroup(id: $id, name: $name, nodes: $nodes, subgroups: $subgroups, type: $type)';
  }
}
