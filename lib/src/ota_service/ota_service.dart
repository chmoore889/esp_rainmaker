import 'package:esp_rainmaker/esp_rainmaker.dart';
import 'package:esp_rainmaker/src/url_base.dart';
import 'package:http/http.dart';
import 'package:isolate_json/isolate_json.dart';

/// Provides access to methods for using the OTA FW service.
class OTAService {
  final String accessToken;
  final URLBase _urlBase;

  static const String _otaBase = 'user/otaimage';

  /// Contructs object to access OTA FW service.
  ///
  /// Requires [accessToken] obtained from authentication.
  /// Uses the default API version of v1, though an
  /// alternative version can be specified.
  OTAService(this.accessToken, [APIVersion version = APIVersion.v1])
      : _urlBase = URLBase(version);

  /// Uploads OTA Image and returns its URL.
  ///
  /// The firmware image, [base64FWImage], must
  /// be a base64 encoded string.
  Future<String> uploadOTAImage(String imageName, String base64FWImage,
      [String? imageType]) async {
    final uri = _urlBase.getPath(_otaBase);

    final body = await JsonIsolate().encodeJson({
      'base64_fwimage': base64FWImage,
      'image_name': imageName,
      'type': imageType,
    });

    final resp = await post(
      uri,
      body: body,
      headers: {
        URLBase.authHeader: accessToken,
      },
    );
    final Map<String, dynamic> bodyResp =
        await JsonIsolate().decodeJson(resp.body);
    if (resp.statusCode != 200) {
      throw bodyResp['description'];
    }

    return bodyResp['image_url'];
  }
}
