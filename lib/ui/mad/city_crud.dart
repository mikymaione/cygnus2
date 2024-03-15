/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:cygnus2/ui/base/screen.dart';
import 'package:cygnus2/ui/forms/city_selector.dart';
import 'package:cygnus2/ui/mad/city.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/utility/generic_controller.dart';

class CityCrud extends StatefulWidget {
  final ValueChanged<City?> onChanged;

  const CityCrud({
    super.key,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _CityCrudState();
}

class _CityCrudState extends State<CityCrud> {
  final formKey = GlobalKey<FormState>();

  final scrollController = ScrollController();

  final controller = GenericController<City>();

  @override
  void dispose() {
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> add() async {
    try {
      widget.onChanged(controller.value);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      Msg.showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Seleziona un comune',
      body: Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // City
                  CitySelector(
                    controller: controller,
                    onSelectionComplete: () => setState(() {}),
                  ),

                  // save button
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: controller.value == null
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              add();
                            }
                          },
                    child: controller.value == null ? const Text('Seleziona') : Text('Seleziona ${controller.value!.name}'),
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
