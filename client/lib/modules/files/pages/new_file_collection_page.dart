import 'package:client/models/collection_model.dart';
import 'package:client/modules/files/pages/rx_files_page.dart';
import 'package:client/repositories/collection_repository.dart';
import 'package:client/repositories/realm_repository.dart';
import 'package:client/services/get_collections_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:realm/realm.dart';

class NewFileCollectionPage extends StatefulWidget {
  const NewFileCollectionPage({super.key});

  @override
  State<NewFileCollectionPage> createState() => _NewFileCollectionPage();
}

class _NewFileCollectionPage extends State<NewFileCollectionPage> {
  String? name;
  String? path;

  //https://pub.dev/packages/reactive_forms
  final form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'path': FormControl<String>(validators: [Validators.required]),
  });

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          child: ReactiveForm(
              formGroup: form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select folder to add.", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
                  Container(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ReactiveTextField(
                          formControlName: 'name',
                          //enabled: _selectedFolder != '',
                          decoration: const InputDecoration(
                            hintText: 'Name of folder',
                            labelText: 'Name *',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ReactiveTextField(
                          formControlName: 'path',
                          //enabled: false,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.folder),
                            hintText: 'Click Browse to select a folder',
                            labelText: 'Folder *',
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () async {
                            String? result = await FilePicker.platform.getDirectoryPath();
                            if (result != null) {
                              //todo set props
                              // set value directly to the control
                              form.control('name').value = result.split("/").last;
                              form.control('path').value = result;

                              //refresh build
                              setState(() {
                                name = result.split("/").last;
                                path = result;
                              });
                            } else {
                              // User canceled the picker, do nothing
                            }
                          },
                          child: const Text("Browse"))
                    ],
                  ),
                  Container(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            //todo disable until path has been picked
                            //Create new object
                            Collection fc = Collection(Uuid.v4().toString(), form.control('name').value,
                                form.control('path').value, "file", "file.local", "pending");

                            CollectionRepository(RealmRepository.instance.database).addCollection(fc).then((value) {
                              GetCollectionsService.instance.invoke(GetCollectionsServiceCommand(null)); //reload all
                              //make new default selected collection
                              RxFilesPage.selectedCollection.add(value);
                            });

                            GoRouter.of(context).go('/files');
                          },
                          child: const Text('Add Folder'))
                    ],
                  ),
                  Container(height: 12),
                ],
              )),
        ),
      ),
    );
  }
}
