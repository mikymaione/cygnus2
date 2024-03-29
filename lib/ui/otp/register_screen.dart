/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/data_structures/profile_data.dart';
import 'package:cygnus2/store/store_auth.dart';
import 'package:cygnus2/ui/base/elevated_wait_button.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/ui/base/screen.dart';
import 'package:cygnus2/ui/base/simple_scrollview.dart';
import 'package:cygnus2/ui/forms/text_editor.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:cygnus2/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:input_dialog/input_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final cSurname = TextEditingController();
  final cName = TextEditingController();
  final cEmail = TextEditingController();
  final cPassword = TextEditingController();

  @override
  void dispose() {
    cSurname.dispose();
    cName.dispose();
    cEmail.dispose();
    cPassword.dispose();

    super.dispose();
  }

  Future<void> register() async {
    if (true == formKey.currentState?.validate()) {
      final storeAuth = StoreAuth();

      try {
        final systemOtp = await storeAuth.sendSignInLinkToEmail(cEmail.text);

        if (mounted) {
          final userOtp = await InputDialog.show(
            context: context,
            title: 'Codice OTP ricevuto via email',
          );

          if (systemOtp == userOtp) {
            final maybeUser = await storeAuth.createUser(
              cEmail.text,
              cPassword.text,
            );

            if (maybeUser == null) {
              if (mounted) {
                Msg.showErrorMsg(context, 'Registrazione fallita!');
              }
            } else {
              final profileData = ProfileData(
                idFirebase: maybeUser.uid,
                created: DateTime.now(),
                surname: cSurname.text,
                name: cName.text,
              );

              await storeAuth.saveProfile(profileData);

              if (mounted) {
                Navigator.pop(context); // RegisterScreen
                Navigator.pop(context); // LoginScreen
              }
            }
          } else {
            if (mounted) {
              Msg.showErrorMsg(context, 'Il codice OTP non corrisponde!');
            }
          }
        }
      } catch (e) {
        if (mounted) {
          Commons.printIfInDebug(e);
          Msg.showError(context, e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Registrazione',
      body: SimpleScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Surname
                      TextEditor(
                        label: 'Cognome',
                        autofillHints: const [AutofillHints.familyName],
                        required: true,
                        minLength: 2,
                        maxLength: 100,
                        controller: cSurname,
                        keyboardType: TextInputType.name,
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                      ),

                      // Nome
                      TextEditor(
                        label: 'Nome',
                        autofillHints: const [AutofillHints.givenName],
                        required: true,
                        minLength: 2,
                        maxLength: 100,
                        controller: cName,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                      ),
                    ],
                  ),
                ),

                AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email
                      TextEditor(
                        label: 'Email universitaria',
                        autofillHints: const [AutofillHints.email],
                        required: true,
                        minLength: 10,
                        maxLength: 320,
                        controller: cEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) => Utility.validateEmail(email),
                        textInputAction: TextInputAction.next,
                      ),

                      // Password
                      TextEditor(
                        label: 'Password',
                        autofillHints: const [AutofillHints.password],
                        required: true,
                        minLength: 8,
                        maxLength: 128,
                        obscureText: true,
                        controller: cPassword,
                        textInputAction: TextInputAction.go,
                        onEditingComplete: () => TextInput.finishAutofillContext(),
                      ),
                    ],
                  ),
                ),

                // check button
                ElevatedWaitButton(
                  child: const Text('Registrati'),
                  onPressed: () async => await register(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
