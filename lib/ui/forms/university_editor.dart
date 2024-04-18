/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/utility/required_generic_controller.dart';
import 'package:cygnus2/utility/utility.dart';
import 'package:flutter/material.dart';

class UniversityEditor extends StatefulWidget {
  final String label;
  final RequiredGenericController<String> controller;
  final FormFieldValidator<String>? validator;

  const UniversityEditor({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
  });

  @override
  State<StatefulWidget> createState() => _UniversityEditorState();
}

class _UniversityEditorState extends State<UniversityEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Text(
            '${widget.label} (obbligatorio)',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          // space
          const SizedBox(height: 8),

          // 4 levels
          DropdownButtonFormField<String>(
            hint: const Text('Clicca per selezionare l’università'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Il campo ${widget.label} è obbligatorio';
              }

              return widget.validator?.call(value);
            },
            value: widget.controller.value,
            onChanged: null,
            items: [
              for (final l in Utility.universities) ...[
                DropdownMenuItem<String>(
                  value: l,
                  child: Text(l),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
