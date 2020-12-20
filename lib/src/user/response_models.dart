import 'package:meta/meta.dart';

/// Data associated with a succesful login.
@immutable
class LoginSuccessResponse {
  final String idToken;
  final String accessToken;

  /// Token used to extend a user session.
  final String refreshToken;

  const LoginSuccessResponse(
      {@required this.idToken,
      @required this.accessToken,
      @required this.refreshToken});

  factory LoginSuccessResponse.fromJson(Map<String, dynamic> json) {
    return LoginSuccessResponse(
      idToken: json['idtoken'],
      accessToken: json['accesstoken'],
      refreshToken: json['refreshtoken'],
    );
  }
}

/// Data associated with a succesful session extension.
@immutable
class ExtendSuccessResponse {
  final String idToken;
  final String accessToken;

  const ExtendSuccessResponse({@required this.idToken, @required this.accessToken});

  factory ExtendSuccessResponse.fromJson(Map<String, dynamic> json) {
    return ExtendSuccessResponse(
      idToken: json['idtoken'],
      accessToken: json['accesstoken'],
    );
  }
}
