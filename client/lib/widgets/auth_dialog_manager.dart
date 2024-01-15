import 'package:client/models/tables/collection.dart';
import 'package:client/oauth/login_providers.dart';
import 'package:client/services/get_collections_service.dart';
import 'package:flutter/material.dart';

class AuthDialogManager {
  AuthDialogManager(this._globalNavigationKey);

  final GlobalKey<NavigatorState> _globalNavigationKey;

  void init() {
    GetCollectionsService.instance.sink.listen((value) {
      for (var c in value) {
        if (c.needsReAuth && c.type == 'email' && c.oauthService == 'google') {
          _showGoogleAuthDialog(c);
        }
      }
    });
  }

  void _showGoogleAuthDialog(Collection collection) {
    showDialog<SimpleDialog>(
        context: _globalNavigationKey.currentState!.context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Authenticate Expired'),
            children: <Widget>[
              const SimpleDialogOption(
                onPressed: null,
                child: Text(
                    "Your Google 'type' oauth token has expired or been reset for 'email'.\nClick button to re-authenticate."),
              ),
              SimpleDialogOption(
                onPressed: null,
                child: SizedBox(
                  width: 225,
                  height: 48,
                  child: ElevatedButton.icon(
                      icon: const Icon(Icons.email),
                      label: const Text("Login with Google"),
                      onPressed: () async {
                        await LoginProviderExtension.handleGoogleMail(context, collection);
                        // TODO close dialog
                      }),
                ),
              ),
            ],
          );
        });
  }
}
