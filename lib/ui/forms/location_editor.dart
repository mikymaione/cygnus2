/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/ui/base/elevated_wait_button.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/utility/generic_controller.dart';
import 'package:cygnus2/utility/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class LocationEditor extends StatefulWidget {
  final GenericController<GeoFirePoint> controller;
  final GenericController<String> controllerA;
  final bool readOnly, required;

  const LocationEditor({
    super.key,
    required this.controllerA,
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
  String? description;

  bool get somethingSelected => widget.controller.value != null;

  @override
  void initState() {
    super.initState();
    description = widget.controllerA.value;
  }

  Future<String> getDescription(GeoFirePoint l) async {
    final maybeAddress = await locationService.addressByGeoPoint(l.geopoint);

    if (maybeAddress != null) {
      if (maybeAddress.city.isNotEmpty) {
        return maybeAddress.city;
      } else if (maybeAddress.road.isNotEmpty) {
        return '${maybeAddress.road} - ${maybeAddress.postalCode}';
      } else if (maybeAddress.postalCode > 0) {
        return 'CAP: ${maybeAddress.postalCode}';
      }
    }

    return 'Lat: ${l.latitude}, Lon: ${l.longitude}';
  }

  Future<void> updateLocation(FormFieldState<bool> formFieldState) async {
    setState(() {
      loading = true;

      description = 'Ricerca posizione...';

      widget.controller.value = null;
      widget.controllerA.value = null;
    });

    try {
      final l = await locationService.getCurrentLocation();
      final a = await getDescription(l);

      setState(() {
        widget.controller.value = l;
        widget.controllerA.value = a;

        description = a;

        formFieldState.didChange(somethingSelected);

        loading = false;
      });
    } catch (e) {
      if (mounted) {
        Msg.showError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: somethingSelected,
      validator: (ok) => ok == true ? null : 'Selezionare una posizione',
      builder: (formFieldState) {
        final themeData = Theme.of(formFieldState.context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Posizione ${widget.required ? ' (obbligatorio)' : ''}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            // position
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(description!),
            ],

            if (!widget.readOnly) ...[
              const SizedBox(height: 8),
              ElevatedWaitButton(
                onPressed: () async => await updateLocation(formFieldState),
                child: const Text('Aggiorna la posizione'),
              ),
            ],

            if (formFieldState.hasError && formFieldState.errorText != null) ...[
              const SizedBox(height: 8),
              Text(
                formFieldState.errorText!,
                style: themeData.textTheme.bodySmall!.copyWith(color: themeData.colorScheme.error),
              ),
            ],
          ],
        );
      },
    );
  }
}
