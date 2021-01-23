import 'dart:convert';
import 'dart:isolate';

class JsonIsolate {
  static final JsonIsolate _singleton = JsonIsolate._internal();

  SendPort sendPort;
  Isolate isolate;

  JsonIsolate._internal();

  factory JsonIsolate() {
    return _singleton;
  }

  Future<dynamic> decodeJson(String json) async {
    if (isolate == null) {
      await _makeIsolate();
    }

    return _sendReceive(sendPort, json, _JsonAction.decode);
  }

  Future<dynamic> encodeJson(dynamic toEncode) async {
    if (isolate == null) {
      await _makeIsolate();
    }

    return _sendReceive(sendPort, toEncode, _JsonAction.encode);
  }

  Future<void> _makeIsolate() async {
    final receivePort = ReceivePort();
    isolate = await Isolate.spawn(
      _isolateDecode,
      receivePort.sendPort,
    );
    sendPort = await receivePort.first;
    receivePort.close();
  }

  Future<dynamic> _sendReceive(
      SendPort port, dynamic json, _JsonAction action) async {
    final response = ReceivePort();
    port.send([json, action, response.sendPort]);
    dynamic decoded = await response.first;
    response.close();
    return decoded;
  }
}

void _isolateDecode(SendPort sendPort) async {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  await for (List msg in receivePort) {
    final message = msg[0];
    final _JsonAction action = msg[1];
    final SendPort replyTo = msg[2];

    dynamic data;
    if (action == _JsonAction.decode) {
      data = jsonDecode(message);
    } else if (action == _JsonAction.encode) {
      data = jsonEncode(message);
    } else {
      throw 'Invalid State';
    }

    replyTo.send(data);
  }
}

enum _JsonAction {
  encode,
  decode,
}
