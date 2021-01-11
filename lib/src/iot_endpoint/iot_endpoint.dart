import 'package:esp_rainmaker/json/json.dart';
import 'package:esp_rainmaker/src/url_base.dart';
import 'package:http/http.dart';

/// Provides access to methods for obtaining the IOT endpoint.
class IOTEndpoint {
  String _urlBase;

  static const String _iotBase = 'mqtt_host';

  /// Contructs object to access IOT endpoint service.
  ///
  /// API doesn't use a version unlike most of the
  /// other services.
  IOTEndpoint() {
    _urlBase = URLBase.getUnversionedBase();
  }

  /// Obtains IOT endpoint.
  ///
  /// Returns the endpoint as a string.
  Future<String> mqttHost() async {
    final url = _urlBase + _iotBase;

    final resp = await get(url);
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return bodyResp['mqtt_host'];
  }
}
