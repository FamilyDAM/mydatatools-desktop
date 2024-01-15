import 'package:client/widgets/setup/setup_stepper_form.dart';
import 'package:flutter/material.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    //final textTheme = Theme.of(context).textTheme;
    //final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Row(
          children: [
            Expanded(
                flex: 4,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 48,
                    ),
                    child: Column(
                      children: [
                        const Text('MyData/Tools', style: TextStyle(fontSize: 56)),
                        Container(height: 16),
                        const Text('Your personal data manager, organizer, and backup tool'),
                        Container(height: 16),
                        const Text(
                            'Keep a local copy of your digital life. \n\n\n'
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ))),
            const Expanded(
                flex: 6,
                child: Dialog(
                  child: SizedBox.expand(
                    child: SetupStepperForm(),
                  ),
                )),
          ],
        ));
  }
}
