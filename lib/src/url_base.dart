import 'package:esp_rainmaker/esp_rainmaker.dart';

/// Gets base string URLs for the API based on the API version.
///
/// Is a fully static class that stores the base URL and
/// provides methods to add data on to the base.
class URLBase {
  static const String _base = 'https://api.rainmaker.espressif.com';
  static const String authHeader = 'Authorization';

  final APIVersion? _version;

  /// Object for making URIs with the given [version].
  URLBase(this._version);

  Uri getPath(String path, [Map<String, String>? queryParameters]) {
    if (_version != null) {
      return Uri.https(
          _base, '/${_version!.toShortString()}/$path', queryParameters);
    }
    return Uri.https(_base, '/$path', queryParameters);
  }
}

extension ParseToString on APIVersion {
  String toShortString() {
    return toString().split('.').last;
  }
}
