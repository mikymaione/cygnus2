/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/ui/base/screen.dart';
import 'package:cygnus2/ui/forms/city_list.dart';
import 'package:cygnus2/ui/mad/mad_filter.dart';
import 'package:cygnus2/utility/generic_controller.dart';
import 'package:flutter/material.dart';

class MadFilters extends StatefulWidget {
  final MadFilter? filters;

  const MadFilters({
    super.key,
    required this.filters,
  });

  @override
  State<StatefulWidget> createState() => _MadFiltersState();
}

class _MadFiltersState extends State<MadFilters> {
  final formKey = GlobalKey<FormState>();

  final scrollController = ScrollController();

  final cCityNames = GenericController<Set<String>>();

  @override
  void initState() {
    super.initState();

    if (widget.filters != null) {
      cCityNames.value ??= {};
      if (widget.filters!.city != null) {
        cCityNames.value!.add(widget.filters!.city!);
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();

    cCityNames.value?.clear();
    cCityNames.dispose();

    super.dispose();
  }

  void clear() {
    if (mounted) {
      final filters = MadFilter.empty();
      Navigator.pop(context, filters);
    }
  }

  void search() {
    if (true == formKey.currentState?.validate()) {
      final filters = MadFilter(
        cleared: false,
        city: cCityNames.value != null && cCityNames.value!.isNotEmpty ? cCityNames.value!.first : null,
      );

      if (mounted) {
        Navigator.pop(context, filters);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Filtra profili',
      body: Scrollbar(
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
                  // City
                  const SizedBox(height: 16),
                  CityList(
                    label: 'Comune (obbligatorio)',
                    subLabel: 'Indicare il comune dove deve recarsi la persona per lo svolgimento dell’attività',
                    buttonLabel: 'Seleziona un comune',
                    controller: cCityNames,
                    readOnly: false,
                    selectOnlyOne: true,
                    validator: (selected) => true == selected ? null : 'Seleziona un comune',
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
      ),
    );
  }
}
