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

  /// The token necessary for the authenticated API calls.
  ///
  /// Store this token for later use.
  final String accessToken;

  const ExtendSuccessResponse(
      {@required this.idToken, @required this.accessToken});

  factory ExtendSuccessResponse.fromJson(Map<String, dynamic> json) {
    return ExtendSuccessResponse(
      idToken: json['idtoken'],
      accessToken: json['accesstoken'],
    );
  }
}

/// Data associated with a user in the Rainmaker server.
@immutable
class UserData {
  final String id;
  final String userName;
  final String name;
  final bool isSuperAdmin;
  final String pictureUrl;

  const UserData(
      {@required this.id,
      @required this.userName,
      @required this.name,
      @required this.isSuperAdmin,
      @required this.pictureUrl});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['user_id'],
      isSuperAdmin: json['super_admin'],
      name: json['name'],
      pictureUrl: json['picture_url'],
      userName: json['user_name'],
    );
  }

  @override
  String toString() {
    return 'UserData(Id: $id, UserName: $userName, IsSuperAdmin: $isSuperAdmin, Name: $name, Pic URL: $pictureUrl)';
  }
}
