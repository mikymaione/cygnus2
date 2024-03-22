/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/ui/base/elevated_wait_button.dart';
import 'package:cygnus2/ui/otp/login_screen.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:flutter/material.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/data_structures/profile_data.dart';
import 'package:cygnus2/store/store_auth.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/ui/base/screen.dart';
import 'package:cygnus2/ui/forms/text_editor.dart';

class ProfileEdit extends StatefulWidget {
  final MyData myProfile;

  const ProfileEdit({
    super.key,
    required this.myProfile,
  });

  @override
  State<StatefulWidget> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final formKey = GlobalKey<FormState>();

  final cSurname = TextEditingController();
  final cName = TextEditingController();
  final cEmail = TextEditingController();

  @override
  void initState() {
    super.initState();

    final storeAuth = StoreAuth();

    final currentUser = storeAuth.currentUser;

    cSurname.text = widget.myProfile.profileData!.surname;
    cName.text = widget.myProfile.profileData!.name;

    if (currentUser != null) {
      cEmail.text = storeAuth.currentUser!.email!;
    }
  }

  @override
  void dispose() {
    cSurname.dispose();
    cName.dispose();
    cEmail.dispose();

    super.dispose();
  }

  Future<void> delete() async {
    final storeAuth = StoreAuth();

    final ok = await Msg.ask(
      context: context,
      title: 'Eliminazione account',
      text: 'Sei sicuro di voler eliminare per sempre il tuo account e tutti i tuoi dati?',
    );

    if (ok) {
      try {
        if (mounted) {
          final ok = await Commons.navigate<bool>(
            context: context,
            builder: (context) => const LoginScreen(),
          );

          if (ok == true) {
            await storeAuth.deleteProfile(widget.myProfile.profileData!.idFirebase);

            if (mounted) {
              Msg.showOk(context, "Profilo eliminato");
              Navigator.pop(context);
            }
          }
        }
      } catch (e) {
        if (mounted) {
          Msg.showError(context, e);
        }
      }
    }
  }

  Future<void> save() async {
    if (true == formKey.currentState?.validate()) {
      final storeAuth = StoreAuth();

      final profileData = ProfileData(
        idFirebase: widget.myProfile.profileData!.idFirebase,
        created: DateTime.now(),
        surname: cSurname.text,
        name: cName.text,
      );

      try {
        await storeAuth.saveProfile(profileData);

        if (mounted) {
          Msg.showOk(context, 'Salvato');
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          Msg.showError(context, e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Profilo',
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Surname
              TextEditor(
                label: 'Cognome',
                required: true,
                minLength: 2,
                maxLength: 100,
                controller: cSurname,
                keyboardType: TextInputType.name,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
              ),

              // Nome
              TextEditor(
                label: 'Nome',
                required: true,
                minLength: 2,
                maxLength: 100,
                controller: cName,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
              ),

              // Email
              TextEditor(
                label: 'Email',
                required: true,
                controller: cEmail,
                readOnly: true,
              ),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedWaitButton(
                    onPressed: () async => await delete(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text('Elimina'),
                  ),
                  ElevatedButton(
                    onPressed: () async => await save(),
                    child: const Text('Salva'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
