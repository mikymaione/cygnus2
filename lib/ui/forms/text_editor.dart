/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextEditor extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int minLength;
  final int? maxLength;
  final double? width;
  final bool obscureText, readOnly, autofocus, required;
  final List<TextInputFormatter>? inputFormatters;
  final GestureTapCallback? onTap;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;

  const TextEditor({
    super.key,
    required this.label,
    required this.controller,
    required this.required,
    this.validator,
    this.onTap,
    this.keyboardType,
    this.inputFormatters,
    this.width,
    this.maxLength,
    this.minLength = 0,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<StatefulWidget> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
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

          // content
          if (widget.readOnly) ...[
            Text(widget.controller.text),
          ] else ...[
            TextFormField(
              textCapitalization: widget.textCapitalization,
              autofocus: widget.autofocus,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              controller: widget.controller,
              maxLength: widget.maxLength,
              obscureText: obscure,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Il campo ${widget.label} è obbligatorio';
                } else if (value.length < widget.minLength) {
                  return 'La lunghezza minima è di ${widget.minLength} caratteri';
                } else {
                  return widget.validator?.call(value);
                }
              },
              decoration: widget.obscureText
                  ? InputDecoration(
                      filled: false,
                      suffixIcon: IconButton(
                        icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => obscure = !obscure),
                      ),
                    )
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}
