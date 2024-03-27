/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/ui/base/simple_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_auth.dart';
import 'package:cygnus2/store/store_push_notifications.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/ui/forms/text_editor.dart';
import 'package:cygnus2/ui/profile/profile_edit.dart';
import 'package:cygnus2/ui/welcome/privacy_policy.dart';
import 'package:cygnus2/ui/welcome/terms_and_conditions.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings extends StatefulWidget {
  final MyData myProfile;

  const Settings({
    super.key,
    required this.myProfile,
  });

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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

  Future<void> logout() async {
    final ok = await Msg.ask(
      context: context,
      title: 'Disconnetti',
      text: 'Sei sicuro di voler disconnetterti?',
    );

    if (ok) {
      final storeAuth = StoreAuth();
      final storePushNotifications = StorePushNotifications(getContext: () => context);

      try {
        await storePushNotifications.logout();
        await storeAuth.logout();

        if (mounted) {
          Msg.showOk(context, 'Disconnesso');
        }
      } catch (e) {
        if (mounted) {
          Msg.showError(context, e);
        }
      }
    }
  }

  Future<String> getVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile
          Card(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Profile
                  const Text(
                    'Profilo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Surname
                  TextEditor(
                    label: 'Cognome',
                    required: true,
                    controller: cSurname,
                    readOnly: true,
                  ),

                  // Nome
                  TextEditor(
                    label: 'Nome',
                    required: true,
                    controller: cName,
                    readOnly: true,
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
                      OutlinedButton(
                        onPressed: () async => await logout(),
                        child: const Text('Disconnetti'),
                      ),
                      ElevatedButton(
                        onPressed: () => Commons.navigate(
                          context: context,
                          builder: (context) => ProfileEdit(
                            myProfile: widget.myProfile,
                          ),
                        ),
                        child: const Text('Modifica'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Privacy and Terms
          Card(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Title Profile
                  const Text(
                    'Termini legali',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () => Commons.navigate(
                      context: context,
                      builder: (context) => const TermsAndConditions(),
                    ),
                    child: const Text('Termini e condizioni'),
                  ),
                  const SizedBox(height: 8),

                  ElevatedButton(
                    onPressed: () => Commons.navigate(
                      context: context,
                      builder: (context) => const PrivacyPolicy(),
                    ),
                    child: const Text('Politica sulla riservatezza'),
                  ),
                ],
              ),
            ),
          ),

          // About
          Card(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Title Profile
                  const Text(
                    'Cygnus2',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  FutureBuilder<String>(
                    future: getVersion(),
                    builder: (context, snapshot) => Text('Versione ${snapshot.data}'),
                  ),
                  const SizedBox(height: 16),

                  Image.asset(
                    'assets/icon/cygnu2.png',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),

                  const SizedBox(height: 16),
                  const Text('© 2024, [MAIONE MIKY]'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
