import 'package:client/app_constants.dart';
import 'package:client/app_logger.dart';
import 'package:client/extensions/widget_extension.dart';
import 'package:client/services/get_user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:password_dart/password_dart.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, this.onLoginSuccessful}) : super(key: key);
  final VoidCallback? onLoginSuccessful;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  AppLogger logger = AppLogger();
  String savedPassword = '';
  //get access to local Secure Storage to save data
  FlutterSecureStorage? secureStorage;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();

    ServicesBinding.instance.keyboard.addHandler(onKey);

    (() async {
      //Pull saved password out of OS secure storage
      if (await secureStorage?.containsKey(key: AppConstants.securePassword) ?? false) {
        String pwd = await secureStorage?.read(key: AppConstants.securePassword) ?? '';
        setState(() {
          savedPassword = pwd;
        });
      } else {
        logger.i("saved password not found");
      }
    }).call();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        height: 300,
        child: Card(
            elevation: 5,
            surfaceTintColor: Colors.white70,
            child: Column(children: [
              const SizedBox(height: 64),
              //todo add padding
              Container(
                  padding: const EdgeInsets.all(16),
                  child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                              name: 'password',
                              initialValue: savedPassword,
                              autofocus: true,
                              decoration: const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ])),
                          Row(
                            children: [
                              SizedBox(
                                  width: 200,
                                  child: FormBuilderCheckbox(
                                    name: 'remember',
                                    title: const Text('Remember Me'),
                                    initialValue: true,
                                  ))
                            ],
                          ),
                          const SizedBox(height: 16),
                          MaterialButton(
                            onPressed: !isSubmitting
                                ? () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      _formKey.currentState?.save();
                                      formSubmitHandler(context,
                                          _formKey.currentState?.instantValue ?? {'password': null, 'remember': false});
                                    }
                                  }
                                : null,
                            child: const Text('Login'),
                          )
                        ],
                      ))),
            ])));
  }

  /// Key listener to allow form submissing when users hits enter
  bool onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (key == 'Enter') {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();
        formSubmitHandler(null, _formKey.currentState?.instantValue ?? {'password': null, 'remember': false});
      }
    }

    return false;
  }

  /// The formSubmitHandler function is used to handle form submissions
  ///
  /// Args:
  ///   context (BuildContext): The `context` parameter in the `formSubmitHandler` function is an object
  /// passed in from the build method
  formSubmitHandler(BuildContext? context, Map<String, dynamic> values) async {
    if (context?.mounted ?? false) {
      setState(() {
        isSubmitting = true;
      });
    }

    String? pwd = values['password'];
    bool remember = values['remember'] ?? false;
    if (pwd != null) {
      var algorithm = PBKDF2(blockLength: 64, iterationCount: 10000, desiredKeyLength: 64);
      var hash = Password.hash(pwd, algorithm);

      var dbUser = await GetUserService.instance.invoke(GetUserServiceCommand(hash));
      if (dbUser != null) {
        widget.onLoginSuccessful!();

        if (remember) {
          //save password to secure storage
          FlutterSecureStorage storage = const FlutterSecureStorage(
            iOptions: IOSOptions(
                groupId: AppConstants.appName, synchronizable: true, accessibility: KeychainAccessibility.first_unlock),
          );
          await storage.write(key: AppConstants.securePassword, value: pwd);
        }
      } else {
        if (context != null && context.mounted) {
          context.showToast("Wrong password");
        }
      }

      if (context?.mounted ?? false) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }
}
