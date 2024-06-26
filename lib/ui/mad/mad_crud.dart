/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/data_structures/image_data.dart';
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_auth.dart';
import 'package:cygnus2/store/store_mad.dart';
import 'package:cygnus2/ui/base/elevated_wait_button.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/ui/forms/date_editor.dart';
import 'package:cygnus2/ui/forms/location_editor.dart';
import 'package:cygnus2/ui/forms/text_editor.dart';
import 'package:cygnus2/ui/forms/university_editor.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:cygnus2/utility/generic_controller.dart';
import 'package:cygnus2/utility/required_generic_controller.dart';
import 'package:cygnus2/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class MadCrudEditor extends StatefulWidget {
  final bool readOnly;
  final MyData myProfile;

  const MadCrudEditor({
    super.key,
    required this.readOnly,
    required this.myProfile,
  });

  @override
  State<StatefulWidget> createState() => _MadCrudEditorState();
}

class _MadCrudEditorState extends State<MadCrudEditor> {
  final storeMad = StoreMad();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: storeMad.madExists(widget.myProfile.profileData?.idFirebase),
      builder: (context, snapExists) => snapExists.data == true
          ? StreamBuilder<MadData?>(
              stream: storeMad.getMad(widget.myProfile.profileData?.idFirebase),
              builder: (context, snapMad) => snapMad.hasData && snapMad.requireData != null
                  ? MadCrud(
                      readOnly: widget.readOnly,
                      myProfile: widget.myProfile,
                      mad: snapMad.requireData,
                    )
                  : Container(),
            )
          : MadCrud(
              readOnly: widget.readOnly,
              myProfile: widget.myProfile,
              mad: null,
            ),
    );
  }
}

class MadCrud extends StatefulWidget {
  final bool readOnly;
  final MyData myProfile;
  final MadData? mad;

  const MadCrud({
    super.key,
    required this.readOnly,
    required this.myProfile,
    required this.mad,
  });

  @override
  State<StatefulWidget> createState() => _MadCrudState();
}

class _MadCrudState extends State<MadCrud> {
  //
  String? get university => Utility.getUniversityByEmail(storeAuth.currentUser?.email);

  final formKey = GlobalKey<FormState>();

  final storeAuth = StoreAuth();

  final cNickname = TextEditingController();

  final cBirthday = GenericController<DateTime>();
  final cBio = TextEditingController();

  late final cUniversity = RequiredGenericController<String>(university!);
  final cDepartment = TextEditingController();

  final cLocation = GenericController<GeoFirePoint>();
  final cAddress = GenericController<String>();

  String? getImageByIndex(List<ImageData> images, int i) => i < images.length ? images[i].base64Image : null;

  @override
  void initState() {
    super.initState();

    cNickname.text = widget.mad?.nickname ?? '';
    cBirthday.value = widget.mad?.birthday;
    cBio.text = widget.mad?.bio ?? '';

    cDepartment.text = widget.mad?.department ?? '';

    cLocation.value = widget.mad?.geoFirePoint;
    cAddress.value = widget.mad?.address;
  }

  @override
  void dispose() {
    cNickname.dispose();
    cBirthday.dispose();
    cBio.dispose();

    cDepartment.dispose();

    cLocation.dispose();

    super.dispose();
  }

  Future<void> save() async {
    if (true == formKey.currentState?.validate()) {
      try {
        final m = MadData(
          idFirebase: widget.myProfile.profileData!.idFirebase,
          personId: widget.myProfile.profileData!.idFirebase,
          nickname: cNickname.text,
          birthday: cBirthday.value!,
          bio: cBio.text,
          university: cUniversity.value,
          department: cDepartment.text,
          location: cLocation.value!.data,
          address: cAddress.value!,
          personWhoLikeMe: widget.mad?.personWhoLikeMe ?? {},
          personWhoDislikeMe: widget.mad?.personWhoDislikeMe ?? {},
          created: DateTime.now(),
        );

        final storeMad = StoreMad();
        await storeMad.saveMad(m);

        if (mounted) {
          Msg.showOk(context, 'Salvato!');
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
    final languageCode = Localizations.localeOf(context).languageCode;

    final years100 = DateTime.now().subtract(const Duration(days: 365 * Commons.maxAgeI));
    final years18 = DateTime.now().subtract(const Duration(days: 365 * Commons.minAgeI));

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nickname
          TextEditor(
            label: 'Nickname',
            controller: cNickname,
            required: !widget.readOnly,
            readOnly: widget.readOnly,
          ),
          const SizedBox(height: 8),

          // Birthday
          DateEditor(
            label: 'Data di nascita',
            controller: cBirthday,
            minValue: years100,
            maxValue: years18,
            languageCode: languageCode,
            readOnly: widget.readOnly,
            required: !widget.readOnly,
          ),
          const SizedBox(height: 16),

          // University
          UniversityEditor(
            label: 'Università',
            controller: cUniversity,
          ),

          // Department
          TextEditor(
            label: 'Dipartimento',
            controller: cDepartment,
            required: !widget.readOnly,
            minLength: 3,
            maxLength: 500,
            readOnly: widget.readOnly,
          ),

          // Bio
          TextEditor(
            label: 'Biografia',
            controller: cBio,
            required: !widget.readOnly,
            minLength: 3,
            maxLength: 500,
            readOnly: widget.readOnly,
          ),

          LocationEditor(
            controller: cLocation,
            controllerA: cAddress,
            required: !widget.readOnly,
            readOnly: widget.readOnly,
          ),

          // save button
          if (!widget.readOnly) ...[
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedWaitButton(
                  onPressed: () async => await save(),
                  child: const Text('Salva'),
                ),
              ],
            )
          ],
        ],
      ),
    );
  }
}
