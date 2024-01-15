import 'dart:convert';

import 'package:client/app_logger.dart';
import 'package:client/oauth/login_providers.dart';
import 'package:http/http.dart' as http;

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  AppLogger logger = AppLogger(null);

  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }

  static Future<String> validateToken(String accessToken, String refreshToken) async {
    // TODO: call Google and refresh the token
    return await _refreshToken(accessToken, refreshToken);
  }

  static Future<String> _refreshToken(String accessToken, String refreshToken) async {
    LoginProviders loginProvider = LoginProviders.google;

    //first check to see if it needs to be refreshed
    bool isExpired = await _isExpiredToken(accessToken);
    if (!isExpired) {
      return accessToken;
    }

    //refresh access token
    String url = "https://www.googleapis.com/oauth2/v4/token";
    Map<String, String> params = {
      'refresh_token': refreshToken,
      'client_id': loginProvider.clientId,
      'client_secret': loginProvider.clientSecret,
      'grant_type': 'refresh_token'
    };
    var httpClient = http.Client();
    http.Response response = await httpClient.post(Uri.parse(url), headers: null, body: params);

    var body = jsonDecode(response.body);
    if (body['access_token'] != null) {
      // TODO save access token to db
      return body['access_token'];
    } else {
      AppLogger(null).e('${body['error_description']}');
      throw Exception(body['error_description']);
      // TODO: flip flag on collection, show warning in UI asking user to reauth acccount.
    }
  }

  static Future<bool> _isExpiredToken(String accessToken) async {
    var httpClient = http.Client();
    String infoUrl = "https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=$accessToken";
    http.Response checkResp = await httpClient.get(Uri.parse(infoUrl), headers: null);
    var checkBody = jsonDecode(checkResp.body);
    return checkBody['expires_in'] == null || int.parse(checkBody['expires_in']) <= 0;
  }
}
