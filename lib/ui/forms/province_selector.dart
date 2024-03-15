/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:cygnus2/ui/mad/city_dao.dart';
import 'package:cygnus2/utility/generic_controller.dart';

class ProvinceSelector extends StatefulWidget {
  final GenericController<String> controller;
  final VoidCallback onSelectionComplete;

  const ProvinceSelector({
    super.key,
    required this.controller,
    required this.onSelectionComplete,
  });

  @override
  State<StatefulWidget> createState() => _ProvinceSelectorState();
}

class _ProvinceSelectorState extends State<ProvinceSelector> {
  String? region;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // REGION
          // title
          const Text(
            'Regione',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          // space
          const SizedBox(height: 8),

          // selector
          DropdownButtonFormField<String>(
            value: region,
            onChanged: (r) => setState(() {
              region = r;
              widget.controller.value = null;
            }),
            items: [
              for (final r in CityDao.regions) ...[
                DropdownMenuItem<String>(
                  value: r,
                  child: Text(r),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // PROVINCE
          // title
          const Text(
            'Provincia',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          // space
          const SizedBox(height: 8),

          // selector
          DropdownButtonFormField<String>(
            value: widget.controller.value,
            onChanged: (p) => setState(() {
              widget.controller.value = p;
              widget.onSelectionComplete();
            }),
            items: [
              if (region != null) ...[
                for (final p in CityDao.provinceByRegion(region!)) ...[
                  DropdownMenuItem<String>(
                    value: p,
                    child: Text(p),
                  ),
                ],
              ],
            ],
          ),
        ],
      ),
    );
  }
}
