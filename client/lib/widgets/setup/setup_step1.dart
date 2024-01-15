import 'package:client/models/tables/app_user.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:password_dart/password_dart.dart';
import 'package:uuid/uuid.dart';

class SetupStep1 extends StatelessWidget {
  SetupStep1({super.key, required this.onCancel, required this.onSubmit});

  final VoidCallback onCancel;
  final void Function(AppUser) onSubmit;

  final infoForm = FormGroup({
    'firstName': FormControl<String>(value: 'mike', validators: [Validators.required]),
    'email': FormControl<String>(value: 'mnimer@gmail.com', validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(value: 'admin', validators: [
      Validators.required,
      Validators.minLength(4),
    ]),
    'confirmPassword': FormControl<String>(value: 'admin', validators: [
      Validators.required,
      Validators.minLength(4),
    ]),
  }, validators: [
    Validators.mustMatch('password', 'confirmPassword')
  ]);

  onStepContinueHandler(BuildContext context) {
    if (infoForm.valid) {
      //Create User
      var name = infoForm.findControl('firstName')?.value;
      var email = infoForm.findControl('email')?.value;
      var password = infoForm.findControl('password')?.value;
      if (password != null) {
        var algorithm = PBKDF2(blockLength: 64, iterationCount: 10000, desiredKeyLength: 64);
        var hash = Password.hash(password, algorithm);

        //double check the hash
        if (!Password.verify(password, hash)) {
          throw Exception('Password hash failed');
        }

        // TODO verify this can be used on server (node & java services)
        //for server side (java) version
        //see https://howtodoinjava.com/java/java-security/how-to-generate-secure-password-hash-md5-sha-pbkdf2-bcrypt-examples/

        //password is a must have required field
        AppUser appUser =
            AppUser(id: const Uuid().v4().toString(), name: name, email: email, password: hash, localStoragePath: '');

        //call callback and proceed to next step
        onSubmit(appUser);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: infoForm,
      child: Column(children: <Widget>[
        ReactiveTextField(
          formControlName: 'firstName',
          decoration: const InputDecoration(
            label: Text('First Name'),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        Container(height: 16),
        ReactiveTextField(
          formControlName: 'email',
          /**
                  validationMessages: {
                    ValidationMessage.required: 'The email must not be empty',
                    ValidationMessage.email: 'The email must be a valid email',
                  },  */
          decoration: const InputDecoration(
            label: Text('Email'),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        Container(height: 16),
        ReactiveTextField(
          formControlName: 'password',
          obscureText: true,
          decoration: const InputDecoration(
            label: Text('Password'),
            prefixIcon: Icon(Icons.password),
          ),
        ),
        Container(height: 16),
        ReactiveTextField(
          formControlName: 'confirmPassword',
          obscureText: true,
          decoration: const InputDecoration(
            label: Text('Confirm Password'),
            prefixIcon: Icon(Icons.password),
          ),
        ),
        ReactiveFormConsumer(
          builder: (context, form, child) {
            return Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 110,
                height: 54,
                child: Row(
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: infoForm.valid ? () => onStepContinueHandler(context) : null,
                      style: ButtonStyle(
                        backgroundColor: infoForm.valid
                            ? MaterialStateProperty.all<Color>(Colors.green)
                            : MaterialStateProperty.all<Color>(Colors.grey),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
