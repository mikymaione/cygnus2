/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:cygnus2/ui/forms/editable_list.dart';
import 'package:cygnus2/ui/mad/city_crud.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:cygnus2/utility/generic_controller.dart';

class CityList extends StatefulWidget {
  final GenericController<Set<String>> controller;
  final bool readOnly, selectOnlyOne;
  final String buttonLabel, label;
  final String? subLabel;
  final VoidCallback? onChanged;
  final FormFieldValidator<bool>? validator;

  const CityList({
    super.key,
    required this.controller,
    required this.readOnly,
    required this.selectOnlyOne,
    required this.buttonLabel,
    required this.label,
    this.subLabel,
    this.onChanged,
    this.validator,
  });

  @override
  State<StatefulWidget> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  bool get somethingSelected => true == widget.controller.value?.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: somethingSelected,
      validator: widget.validator,
      builder: (formFieldState) {
        final themeData = Theme.of(formFieldState.context);

        return Container(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(
                widget.label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              // sub-title
              if (widget.subLabel != null) ...[
                // space
                const SizedBox(height: 8),
                Text(
                  widget.subLabel!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],

              // space
              const SizedBox(height: 8),

              // cities
              EditableList<String>(
                items: widget.controller.value,
                getDescription: (i) => i,
                onDelete: widget.readOnly
                    ? null
                    : (i) => setState(() {
                          widget.controller.value?.remove(i);
                          widget.onChanged?.call();
                          formFieldState.didChange(somethingSelected);
                        }),
              ),

              if (!widget.readOnly) ...[
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Commons.navigate(
                    context: context,
                    builder: (context) => CityCrud(
                      onChanged: (c) => setState(() {
                        if (c != null) {
                          widget.controller.value ??= {}; // if null create it

                          if (widget.selectOnlyOne && widget.controller.value?.length == 1) {
                            // you can have only 1 item
                            widget.controller.value!.clear();
                          }

                          widget.controller.value!.add(c.name);
                        }

                        widget.onChanged?.call();
                        formFieldState.didChange(somethingSelected);
                      }),
                    ),
                  ),
                  child: Text(widget.buttonLabel),
                ),
              ],

              if (formFieldState.hasError && formFieldState.errorText != null) ...[
                // space
                const SizedBox(height: 8),

                // error text
                Text(
                  formFieldState.errorText!,
                  style: themeData.textTheme.bodySmall!.copyWith(color: themeData.colorScheme.error),
                ),

                // space
                const SizedBox(height: 8),
              ],
            ],
          ),
        );
      },
    );
  }
}
