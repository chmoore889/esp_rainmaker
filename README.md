

## Usage

A simple usage example:

```dart
import 'package:esp_rainmaker/esp_rainmaker.dart';

Future<void> main() async {
  final rainmaker = Rainmaker(APIVersion.v1);

  //Create new user
  await rainmaker.user.createUser('email@email.com', 'password12345');

  //Login and extend session
  final login = await rainmaker.user.login('email@email.com', 'password12345');
  await rainmaker.user.extendSession('email@email.com', login.refreshToken);

  //Add node mapping and check status
  final reqId = await rainmaker.nodeAssociation.addNodeMapping('nodeid1234', 'very_secret_key');
  await rainmaker.nodeAssociation.getMappingStatus(reqId);
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
