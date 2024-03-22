/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/store/store_auth.dart';
import 'package:cygnus2/ui/base/elevated_wait_button.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/ui/base/screen.dart';
import 'package:cygnus2/ui/forms/text_editor.dart';
import 'package:cygnus2/ui/otp/register_screen.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:cygnus2/utility/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storeAuth = StoreAuth();

  final formKey = GlobalKey<FormState>();

  final cEmail = TextEditingController();
  final cPassword = TextEditingController();

  @override
  void dispose() {
    cEmail.dispose();
    cPassword.dispose();

    super.dispose();
  }

  Future<void> recoveryPassword() async {
    if (true == formKey.currentState?.validate()) {
      try {
        await storeAuth.sendPasswordResetEmail(
          cEmail.text,
        );

        if (mounted) {
          Msg.showInfo(context, 'Email di recupero inviata a: ${cEmail.text}');
        }
      } catch (e) {
        if (mounted) {
          Msg.showError(context, e);
        }
      }
    }
  }

  Future<void> enter() async {
    if (true == formKey.currentState?.validate()) {
      try {
        final maybeUser = await storeAuth.login(
          cEmail.text,
          cPassword.text,
        );

        if (maybeUser == null) {
          if (mounted) {
            Msg.showErrorMsg(context, 'Autenticazione fallita!');
          }
        } else {
          final profileData = await storeAuth.getMyProfile(maybeUser.uid);

          if (profileData == null) {
            if (mounted) {
              Msg.showErrorMsg(context, 'Autenticazione fallita!');
            }
          } else {
            if (mounted) {
              Navigator.pop(context, true);
            }
          }
        }
      } on FirebaseAuthException catch (a) {
        if (mounted) {
          Msg.showErrorMsg(context, 'Errore: ${a.message}');
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
      title: 'Autenticazione',
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email
              TextEditor(
                label: 'Email',
                required: true,
                minLength: 10,
                maxLength: 320,
                controller: cEmail,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                validator: (email) => Utility.validateEmail(email),
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
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ElevatedWaitButton(
                    child: const Text('Accedi'),
                    onPressed: () async => await enter(),
                  ),
                  if (storeAuth.currentUser == null) ...[
                    OutlinedButton(
                      child: const Text('Registrati'),
                      onPressed: () => Commons.navigate(
                        context: context,
                        builder: (context) => const RegisterScreen(),
                      ),
                    ),
                    OutlinedButton(
                      child: const Text('Recupero Password'),
                      onPressed: () async => await recoveryPassword(),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
