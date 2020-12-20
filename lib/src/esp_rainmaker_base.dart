import 'package:esp_rainmaker/src/nodes/node_association.dart';
import 'package:esp_rainmaker/src/user/user.dart';

enum APIVersion {
  v1
}

class Rainmaker {
  User user;
  NodeAssociation nodeAssociation;

  Rainmaker(APIVersion version) {
    user = User(version);
    nodeAssociation = NodeAssociation(version);
  }
}
