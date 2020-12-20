import 'dart:convert';

import 'package:esp_rainmaker/src/esp_rainmaker_base.dart';
import 'package:esp_rainmaker/src/user/response_models.dart';
import 'package:esp_rainmaker/src/url_base.dart';
import 'package:http/http.dart';

class User {
  static const String _createConfirmEndpoint = 'user';
  static const String _loginEndpoint = 'login';
  static const String _passwordChangeEndpoint = 'password';
  static const String _forgotPasswordEndpoint = 'forgotpassword';
  
  String _urlBase;

  User(APIVersion version) {
    _urlBase = URLBase.getBase(version);
  }

  Future<void> createUser(String userName, String password) async {
    final url = _urlBase + _createConfirmEndpoint;

    final body = jsonEncode({
      'user_name': userName,
      'password': password,
    });
  
    final resp = await post(url, body: body);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 201) {
      throw bodyResp['description'];
    }
  }

  Future<void> confirmUser(String userName, String verifCode) async {
    final url = _urlBase + _createConfirmEndpoint;

    final body = jsonEncode({
      'user_name': userName,
      'verification_code': verifCode,
    });

    final resp = await post(url, body: body);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 201) {
      throw bodyResp['description'];
    }

  }

  Future<LoginSuccessResponse> login(String userName, String password) async {
    final url = _urlBase + _loginEndpoint;

    final body = jsonEncode({
      'user_name': userName,
      'password': password,
    });

    final resp = await post(url, body: body);
    final Map<String, dynamic> bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }
    return LoginSuccessResponse.fromJson(bodyResp);
  }

  Future<ExtendSuccessResponse> extendSession(String userName, String refreshtoken) async {
    final url = _urlBase + _loginEndpoint;

    final body = jsonEncode({
      'user_name': userName,
      'refreshtoken': refreshtoken,
    });

    final resp = await post(url, body: body);
    final bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }
    return ExtendSuccessResponse.fromJson(bodyResp);
  }

  Future<void> changePassword(String password, String newPassword, String accessToken) async {
    final url = _urlBase + _passwordChangeEndpoint;

    final body = jsonEncode({
      'password': password,
      'newpassword': newPassword,
      'accesstoken': accessToken,
    });

    final resp = await post(url, body: body);
    final bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  Future<void> reqForgotPass(String userName) async {
    final url = _urlBase + _forgotPasswordEndpoint;

    final body = jsonEncode({
      'user_name': userName,
    });

    final resp = await post(url, body: body);
    final bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }

  Future<void> confirmForgotPass(String userName, String password, String verificationCode) async {
    final url = _urlBase + _forgotPasswordEndpoint;

    final body = jsonEncode({
      'user_name': userName,
      'password': password,
      'verification_code': verificationCode,
    });

    final resp = await post(url, body: body);
    final bodyResp = jsonDecode(resp.body);
    if(resp.statusCode != 200) {
      throw bodyResp['description'];
    }
  }
}
