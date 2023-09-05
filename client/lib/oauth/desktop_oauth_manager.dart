import 'dart:io';

import 'package:client/oauth/desktop_login_manager.dart';
import 'package:client/oauth/login_providers.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;

///
/// Based on this stackoverflow answer
/// https://stackoverflow.com/questions/68716993/google-microsoft-oauth2-login-flow-flutter-desktop-macos-windows-linux
class DesktopOAuthManager extends DesktopLoginManager {
  final LoginProviders loginProvider;

  DesktopOAuthManager({required this.loginProvider}) : super();

  Future<oauth2.Client> login() async {
    await redirectServer?.close();
    // Bind to an ephemeral port on localhost
    redirectServer = await HttpServer.bind('localhost', 0);
    final redirectURL = 'http://localhost:${redirectServer!.port}/auth';
    var client = await _getOAuth2Client(Uri.parse(redirectURL));
    return client;
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    var grant = oauth2.AuthorizationCodeGrant(
      loginProvider.clientId,
      Uri.parse(loginProvider.authorizationEndpoint),
      Uri.parse(loginProvider.tokenEndpoint),
      httpClient: _JsonAcceptingHttpClient(),
      secret: loginProvider.clientSecret,
    );
    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl, scopes: loginProvider.scopes);

    await redirect(authorizationUrl);
    var responseQueryParameters = await listen();
    var client = await grant.handleAuthorizationResponse(responseQueryParameters);
    return client;
  }
}

class _JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}
