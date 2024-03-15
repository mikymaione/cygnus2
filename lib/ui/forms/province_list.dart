/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:cygnus2/ui/forms/editable_list.dart';
import 'package:cygnus2/ui/mad/province_selector_screen.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:cygnus2/utility/generic_controller.dart';

class ProvinceList extends StatefulWidget {
  final GenericController<Set<String>> controller;
  final bool readOnly;
  final String buttonLabel;
  final VoidCallback? onChanged;

  const ProvinceList({
    super.key,
    required this.controller,
    required this.readOnly,
    required this.buttonLabel,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _ProvinceListState();
}

class _ProvinceListState extends State<ProvinceList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          const Text(
            'Province',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

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
                    }),
          ),

          if (!widget.readOnly) ...[
            const SizedBox(height: 8),
            ElevatedButton(
              child: Text(widget.buttonLabel),
              onPressed: () => Commons.navigate(
                context: context,
                builder: (context) => ProvinceSelectorScreen(
                  onChanged: (p) => setState(() {
                    if (p != null) {
                      widget.controller.value ??= {}; // if null create it
                      widget.controller.value!.add(p);
                    }

                    widget.onChanged?.call();
                  }),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
