/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:cygnus2/ui/forms/city_list.dart';
import 'package:cygnus2/ui/forms/province_list.dart';
import 'package:cygnus2/utility/generic_controller.dart';

class ProvinceOrCityForm extends StatefulWidget {
  final bool readOnly;
  final GenericController<Set<String>> cCityNames, cProvinces;
  final FormFieldValidator<bool>? validator;

  const ProvinceOrCityForm({
    super.key,
    required this.readOnly,
    required this.cCityNames,
    required this.cProvinces,
    this.validator,
  });

  @override
  State<StatefulWidget> createState() => _ProvinceOrCityFormState();
}

class _ProvinceOrCityFormState extends State<ProvinceOrCityForm> {
  bool get somethingSelected => true == widget.cProvinces.value?.isNotEmpty || true == widget.cCityNames.value?.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: somethingSelected,
      validator: widget.validator,
      builder: (formFieldState) {
        final themeData = Theme.of(formFieldState.context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Province
            ProvinceList(
              buttonLabel: 'Aggiungi una provincia',
              controller: widget.cProvinces,
              readOnly: widget.readOnly,
              onChanged: () => formFieldState.didChange(somethingSelected),
            ),

            // City
            CityList(
              label: 'Comuni',
              buttonLabel: 'Aggiungi un comune',
              controller: widget.cCityNames,
              readOnly: widget.readOnly,
              selectOnlyOne: false,
              onChanged: () => formFieldState.didChange(somethingSelected),
            ),

            if (formFieldState.hasError && formFieldState.errorText != null) ...[
              // error text
              Text(
                formFieldState.errorText!,
                style: themeData.textTheme.bodySmall!.copyWith(color: themeData.colorScheme.error),
              ),

              // space
              const SizedBox(height: 16),
            ],
          ],
        );
      },
    );
  }
}
