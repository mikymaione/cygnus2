/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/utility/generic_controller.dart';
import 'package:cygnus2/utility/utility.dart';
import 'package:flutter/material.dart';

class DateEditor extends StatefulWidget {
  final GenericController<DateTime> controller;
  final String label, languageCode;
  final bool readOnly, required;
  final DateTime minValue, maxValue;

  const DateEditor({
    super.key,
    required this.controller,
    required this.languageCode,
    required this.label,
    required this.readOnly,
    required this.required,
    required this.minValue,
    required this.maxValue,
  });

  @override
  State<StatefulWidget> createState() => _DateEditorState();
}

class _DateEditorState extends State<DateEditor> {
  final c1 = TextEditingController();

  Future<DateTime?> selectDate(DateTime initialDate, DateTime firstDate, DateTime lastDate) => showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );

  void setData() {
    if (widget.controller.value != null) {
      c1.text = Utility.datetimeYMMMMD(widget.languageCode, widget.controller.value!);
    }
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  void dispose() {
    c1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        Text(
          widget.label + (widget.required ? ' (obbligatorio)' : ''),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),

        // from
        if (widget.readOnly) ...[
          Text(
            c1.text,
            textAlign: TextAlign.justify,
          ),
        ] else ...[
          TextFormField(
            controller: c1,
            readOnly: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                if (widget.required) {
                  return 'Il campo ${widget.label} è obbligatorio';
                }
              }

              return null;
            },
            onTap: widget.readOnly
                ? null
                : () async {
                    final d = await selectDate(
                      widget.controller.value ?? widget.maxValue,
                      widget.minValue,
                      widget.maxValue,
                    );

                    // d = 01/02/1998 00:00:00
                    setState(() {
                      widget.controller.value = d;
                      setData();
                    });
                  },
          ),
        ],

        // space
        const SizedBox(height: 16),
      ],
    );
  }
}
