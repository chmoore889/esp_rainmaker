import 'package:esp_rainmaker/src/url_base.dart';
import 'package:http/http.dart';
import 'package:isolate_json/isolate_json.dart';

/// Provides access to methods for obtaining the IOT endpoint.
class IOTEndpoint {
  final URLBase _urlBase;

  static const String _iotBase = 'mqtt_host';

  /// Contructs object to access IOT endpoint service.
  ///
  /// API doesn't use a version unlike most of the
  /// other services.
  IOTEndpoint() : _urlBase = URLBase(null);

  /// Obtains IOT endpoint.
  ///
  /// Returns the endpoint as a string.
  Future<String> mqttHost() async {
    final url = _urlBase.getPath(_iotBase);

    final resp = await get(url);
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return bodyResp['mqtt_host'];
  }
}
