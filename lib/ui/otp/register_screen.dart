/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:cygnus2/data_structures/profile_data.dart';
import 'package:cygnus2/ui/base/screen.dart';
import 'package:cygnus2/store/store_auth.dart';
import 'package:cygnus2/ui/forms/text_editor.dart';
import 'package:cygnus2/ui/base/msg.dart';

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
    final storeAuth = StoreAuth();

    try {
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
    } catch (e) {
      if (mounted) {
        Msg.showError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Registrazione',
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
                minLength: 3,
                maxLength: 320,
                controller: cEmail,
                keyboardType: TextInputType.emailAddress,
              ),

              // Password
              TextEditor(
                label: 'Password',
                required: true,
                minLength: 8,
                maxLength: 128,
                obscureText: true,
                controller: cPassword,
              ),

              // check button
              ElevatedButton(
                child: const Text('Registrati'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await register();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
