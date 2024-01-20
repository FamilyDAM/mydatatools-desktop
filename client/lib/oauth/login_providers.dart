import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:client/app_constants.dart';
import 'package:client/main.dart';
import 'package:client/models/tables/collection.dart';
import 'package:client/modules/email/pages/email_page.dart';
import 'package:client/repositories/collection_repository.dart';
import 'package:client/services/get_collections_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/oauth/desktop_oauth_manager.dart';
import 'package:uuid/uuid.dart';

enum LoginProviders { google, azure }

///
/// Based on this stackoverflow answer
/// https://stackoverflow.com/questions/68716993/google-microsoft-oauth2-login-flow-flutter-desktop-macos-windows-linux
extension LoginProviderExtension on LoginProviders {
  String get key {
    switch (this) {
      case LoginProviders.google:
        return 'google';
      case LoginProviders.azure:
        return 'azure';
    }
  }

  String get authorizationEndpoint {
    switch (this) {
      case LoginProviders.google:
        return "https://accounts.google.com/o/oauth2/v2/auth";
      case LoginProviders.azure:
        return "https://login.microsoftonline.com/common/oauth2/v2.0/authorize";
    }
  }

  String get tokenEndpoint {
    switch (this) {
      case LoginProviders.google:
        return "https://oauth2.googleapis.com/token";
      case LoginProviders.azure:
        return "https://login.microsoftonline.com/common/oauth2/v2.0/token";
    }
  }

  String get clientId {
    switch (this) {
      case LoginProviders.google:
        return "279909695629-gmhsdqgh5jsrpq2nnd2aeisecpm1qrhq.apps.googleusercontent.com";
      case LoginProviders.azure:
        return "AZURE_CLIENT_ID";
    }
  }

  String get clientSecret {
    switch (this) {
      case LoginProviders.google:
        return "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"; // if applicable
      case LoginProviders.azure:
        return "AZURE_SECRET"; // if applicable
    }
  }

  List<String> get scopes {
    switch (this) {
      case LoginProviders.google:
        return [
          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/user.emails.read',
          'https://www.googleapis.com/auth/gmail.readonly',
        ]; // if applicable
      case LoginProviders.azure:
        return ['openid', 'email']; // OAuth Scopes
    }
  }

  static handleGoogleMail(BuildContext context, Collection? collection) async {
    String appDatabase = MainApp.appDatabase.value;

    //Scopes:
    //https://www.googleapis.com/auth/gmail.readonly
    // TODO: Security Assessment will be required
    //@see https://support.google.com/cloud/answer/9110914#zippy=%2Cgmail-api%2Cexceptions-to-verification-requirements%2Csteps-to-prepare-for-verification%2Csteps-for-apps-requesting-sensitive-scopes%2Csteps-for-apps-requesting-restricted-scopes%2Csteps-to-submit-your-app%2Csecurity-assessment
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      final provider = DesktopOAuthManager(loginProvider: LoginProviders.google);

      var client = await provider.login();
      //print('token=${client.credentials.accessToken}');

      /// Handle successful login by creating a new collection for the user or updating current collection
      var peopleUrl = Uri.parse("https://people.googleapis.com/v1/people/me?personFields=emailAddresses");
      var response = await http.get(peopleUrl, headers: {"Authorization": "Bearer ${client.credentials.accessToken}"});
      if (response.statusCode == 200) {
        Map<String, dynamic> user = jsonDecode(response.body);

        var userId = user['resourceName'].split("/")[1];
        var emails = user['emailAddresses'] as List;
        var email = emails.firstWhere((element) => (element['metadata']['primary'] ?? false) == true)['value'];

        var id = collection?.id ?? const Uuid().v4().toString();
        var root = File(appDatabase);

        // Create/Update Collection with the following bits of oauth data
        Collection c = Collection(
            id: id,
            name: email,
            path: "${root.path}/files/email/$email",
            type: "email",
            scanner: AppConstants.scannerEmailGmail,
            scanStatus: "pending",
            oauthService: "google",
            accessToken: client.credentials.accessToken,
            refreshToken: client.credentials.refreshToken,
            idToken: client.credentials.idToken,
            userId: userId,
            expiration: client.credentials.expiration,
            needsReAuth: false);

        //Save collection
        CollectionRepository().addCollection(c).then((value) {
          GetCollectionsService.instance.invoke(GetCollectionsServiceCommand("email")); //reload all
          //make new default selected collection
          EmailPage.selectedCollection.add(value);
          //context.go("/email");
        });

        return Future(() => c);
      } else {
        print("Error");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unsupported platform, open up the desktop version of this application to add new accounts.')));
    }
  }
}
