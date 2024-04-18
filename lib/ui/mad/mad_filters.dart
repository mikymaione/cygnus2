/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/data_structures/mad_filter.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_filter.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/ui/base/screen.dart';
import 'package:cygnus2/ui/base/simple_scrollview.dart';
import 'package:cygnus2/ui/forms/distance_slider_editor.dart';
import 'package:cygnus2/utility/generic_controller.dart';
import 'package:flutter/material.dart';

class MadFilters extends StatefulWidget {
  final MyData myProfile;
  final MadFilter? filters;

  const MadFilters({
    super.key,
    required this.myProfile,
    required this.filters,
  });

  @override
  State<StatefulWidget> createState() => _MadFiltersState();
}

class _MadFiltersState extends State<MadFilters> {
  final formKey = GlobalKey<FormState>();

  final cKm = GenericController<double>();

  @override
  void initState() {
    super.initState();

    cKm.value = widget.filters?.km?.toDouble();
  }

  @override
  void dispose() {
    cKm.dispose();

    super.dispose();
  }

  Future<void> save(MadFilter f) async {
    final storeFilter = StoreFilter();

    try {
      await storeFilter.saveFilter(f);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Msg.showError(context, e);
      }
    }
  }

  void clear() {
    final f = MadFilter(
      idFirebase: widget.myProfile.profileData?.idFirebase,
      cleared: true,
      km: cKm.value?.ceil(),
    );

    save(f);
  }

  void search() {
    if (true == formKey.currentState?.validate()) {
      final f = MadFilter(
        idFirebase: widget.myProfile.profileData?.idFirebase,
        cleared: false,
        km: cKm.value?.ceil(),
      );

      save(f);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Filtra profili',
      body: SimpleScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // distance
                DistanceSliderEditor(
                  controller: cKm,
                ),

                // save button
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      child: const Text('Cancella filtri'),
                      onPressed: () => clear(),
                    ),
                    ElevatedButton(
                      child: const Text('Applica filtri'),
                      onPressed: () => search(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
