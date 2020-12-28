import 'package:esp_rainmaker/esp_rainmaker.dart';

/// Gets base string URLs for the API based on the API version.
///
/// Is a fully static class that stores the base URL and
/// provides methods to add data on to the base.
class URLBase {
  static const String _base = 'https://api.rainmaker.espressif.com/';
  static const String authHeader = 'Authorization';

  /// Gets the base API url with the given [version].
  static String getBase([APIVersion version = APIVersion.v1]) {
    return _base + version.toShortString() + '/';
  }

  /// Gets the base API url without any verion information.
  static String getUnversionedBase() {
    return _base + '/';
  }

  /// Returns a query parameter string.
  ///
  /// Uses the inputted arguments to form a query
  /// parameter string starting with `'?'`.
  static String getQueryParams(Map<String, dynamic> params) {
    return '?' + Uri(queryParameters: params).query;
  }
}

extension ParseToString on APIVersion {
  String toShortString() {
    return toString().split('.').last;
  }
}
