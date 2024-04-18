/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/utility/commons.dart';
import 'package:cygnus2/utility/generic_controller.dart';
import 'package:flutter/material.dart';

class AgeSliderEditor extends StatefulWidget {
  final GenericController<RangeValues> controller;

  const AgeSliderEditor({
    super.key,
    required this.controller,
  });

  @override
  State<AgeSliderEditor> createState() => _AgeSliderEditorState();
}

class _AgeSliderEditorState extends State<AgeSliderEditor> {
  RangeValues get curValue => widget.controller.value ?? Commons.defaultAge;

  late RangeValues ageInTitle = curValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Età (${ageInTitle.start.floor()} - ${ageInTitle.end.ceil()} anni)',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          RangeSlider(
            min: Commons.minAge,
            max: Commons.maxAge,
            divisions: 112,
            labels: RangeLabels(
              '${curValue.start.floor()} anni',
              '${curValue.end.ceil()} anni',
            ),
            values: widget.controller.value ?? Commons.defaultAge,
            onChangeEnd: (_) => setState(
              () => ageInTitle = curValue,
            ),
            onChanged: (anni) => setState(
              () => widget.controller.value = anni,
            ),
          ),
        ],
      ),
    );
  }
}
