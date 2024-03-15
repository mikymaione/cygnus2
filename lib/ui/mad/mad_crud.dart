/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_mad.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/ui/forms/date_editor.dart';
import 'package:cygnus2/ui/forms/province_or_city_form.dart';
import 'package:cygnus2/ui/forms/text_editor.dart';
import 'package:cygnus2/ui/mad/city_dao.dart';
import 'package:cygnus2/utility/generic_controller.dart';
import 'package:flutter/material.dart';

class MadCrud extends StatefulWidget {
  final bool readOnly, showSendMsgButton;
  final MyData? myProfile;
  final MadData? mad;

  const MadCrud({
    super.key,
    required this.readOnly,
    required this.showSendMsgButton,
    required this.myProfile,
    required this.mad,
  });

  @override
  State<StatefulWidget> createState() => _MadCrudState();
}

class _MadCrudState extends State<MadCrud> {
  final formKey = GlobalKey<FormState>();

  final scrollController = ScrollController();

  final cNickname = TextEditingController();

  final cBirthday = GenericController<DateTime>();
  final cBio = TextEditingController();

  final cUniversity = TextEditingController();
  final cDepartment = TextEditingController();

  // bse64
  final cImg1 = GenericController<String>();
  final cImg2 = GenericController<String>();
  final cImg3 = GenericController<String>();
  final cImg4 = GenericController<String>();
  final cImg5 = GenericController<String>();
  final cImg6 = GenericController<String>();

  final cCityNames = GenericController<Set<String>>();
  final cProvinces = GenericController<Set<String>>();

  @override
  void initState() {
    super.initState();

    if (widget.mad != null) {
      cCityNames.value = widget.mad!.whereCityName;
      cProvinces.value = widget.mad!.whereProvince;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();

    cNickname.dispose();
    cBirthday.dispose();
    cBio.dispose();

    cUniversity.dispose();
    cDepartment.dispose();

    cImg1.dispose();
    cImg2.dispose();
    cImg3.dispose();
    cImg4.dispose();
    cImg5.dispose();
    cImg6.dispose();

    cCityNames.value?.clear();
    cCityNames.dispose();

    cProvinces.value?.clear();
    cProvinces.dispose();

    super.dispose();
  }

  Future<void> save() async {
    if (formKey.currentState!.validate()) {
      try {
        // add all city in a province
        final whereProvinceCitiesName = {
          for (final p in cProvinces.value ?? <String>{})
            for (final c in CityDao.citiesByProvince(p)) c.name
        };

        // add the cities
        for (final c in cCityNames.value ?? <String>{}) {
          whereProvinceCitiesName.add(c);
        }

        final m = MadData(
          idFirebase: widget.mad?.idFirebase,
          updated: DateTime.now(),
          personId: widget.myProfile!.profileData.idFirebase,
          nickname: cNickname.text,
          birthday: cBirthday.value!,
          bio: cBio.text,
          university: cUniversity.text,
          department: cDepartment.text,
          img1: cImg1.value!,
          img2: cImg2.value,
          img3: cImg3.value,
          img4: cImg4.value,
          img5: cImg5.value,
          img6: cImg6.value,
          whereCityName: cCityNames.value ?? {},
          whereProvince: cProvinces.value ?? {},
          whereProvinceCitiesName: whereProvinceCitiesName,
        );

        m.idFirebase = await StoreMad().saveMad(m);

        if (mounted) {
          Navigator.pop(context);
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

    final years100 = DateTime.now().subtract(const Duration(days: 365 * 100));
    final years18 = DateTime.now().subtract(const Duration(days: 365 * 18));

    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nickname
                TextEditor(
                  label: 'Nickname',
                  controller: cNickname,
                  required: true,
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
                ),
                const SizedBox(height: 8),

                // University
                TextEditor(
                  label: 'Università',
                  controller: cUniversity,
                  required: true,
                  minLength: 5,
                  maxLength: 500,
                  readOnly: widget.readOnly,
                ),
                const SizedBox(height: 8),

                // Department
                TextEditor(
                  label: 'Dipartimento',
                  controller: cDepartment,
                  required: true,
                  minLength: 3,
                  maxLength: 500,
                  readOnly: widget.readOnly,
                ),
                const SizedBox(height: 8),

                // Bio
                TextEditor(
                  label: 'Biografia',
                  controller: cBio,
                  required: true,
                  minLength: 3,
                  maxLength: 500,
                  readOnly: widget.readOnly,
                ),
                const SizedBox(height: 8),

                // Province & City
                const SizedBox(height: 8),
                const Text(
                  'Dove ti trovi? (è obbligatorio selezionare almeno uno tra comune o provincia)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                ProvinceOrCityForm(
                  cCityNames: cCityNames,
                  cProvinces: cProvinces,
                  readOnly: widget.readOnly,
                  validator: (selected) => true == selected ? null : 'Seleziona almeno una provincia o un comune',
                ),

                // save button
                if (!widget.readOnly) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => save(),
                    child: const Text('Salva'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
