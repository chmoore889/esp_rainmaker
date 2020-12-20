import 'package:esp_rainmaker/src/esp_rainmaker_base.dart';

class URLBase {
  static const String _base = 'https://swaggerapis.rainmaker.espressif.com/';

  static String getBase(APIVersion version) {
    return _base + version.toShortString() + '/';
  }

  static String getQueryParams(Map<String, dynamic> params) {
    return '?' + Uri(queryParameters: params).query;
  }
}

extension ParseToString on APIVersion {
  String toShortString() {
    return toString().split('.').last;
  }
}