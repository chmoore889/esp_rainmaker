import 'package:meta/meta.dart';

@immutable
class LoginSuccessResponse {
  final String idToken;
  final String accessToken;
  final String refreshToken;

  LoginSuccessResponse({@required this.idToken, @required this.accessToken, @required this.refreshToken});

  factory LoginSuccessResponse.fromJson(Map<String, dynamic> json) {
    return LoginSuccessResponse(
      idToken: json['idtoken'],
      accessToken: json['accesstoken'],
      refreshToken: json['refreshtoken'],
    );
  }
}

@immutable
class ExtendSuccessResponse {
  final String idToken;
  final String accessToken;

  ExtendSuccessResponse({@required this.idToken, @required this.accessToken});

  factory ExtendSuccessResponse.fromJson(Map<String, dynamic> json) {
    return ExtendSuccessResponse(
      idToken: json['idtoken'],
      accessToken: json['accesstoken'],
    );
  }
}