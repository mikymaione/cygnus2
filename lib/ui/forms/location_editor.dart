/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/utility/generic_controller.dart';
import 'package:cygnus2/utility/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class LocationEditor extends StatefulWidget {
  final GenericController<GeoFirePoint> controller;
  final bool readOnly, required;

  const LocationEditor({
    super.key,
    required this.controller,
    required this.readOnly,
    required this.required,
  });

  @override
  State<LocationEditor> createState() => _LocationEditorState();
}

class _LocationEditorState extends State<LocationEditor> {
  final locationService = LocationService();

  var loading = false;

  String? get description {
    final l = widget.controller.value;

    return loading
        ? 'Ricerca posizione...'
        : l == null
            ? null
            : 'Lat: ${l.latitude}, Lon: ${l.longitude}';
  }

  Future<void> updateLocation() async {
    setState(() {
      loading = true;
      widget.controller.value = null;
    });

    final l = await locationService.getCurrentLocation();

    setState(() {
      widget.controller.value = l;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: widget.controller.value != null,
      validator: (ok) => ok == true ? null : 'Selezionare una posizione',
      builder: (formFieldState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posizione ${widget.required ? ' (obbligatorio)' : ''}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // position
          if (description != null) ...[
            Text(description!),
            const SizedBox(height: 8),
          ],

          if (!widget.readOnly) ...[
            ElevatedButton(
              onPressed: loading ? null : () => updateLocation(),
              child: const Text('Aggiorna la posizione'),
            ),
          ],
        ],
      ),
    );
  }
}
