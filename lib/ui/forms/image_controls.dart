/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';

class ImageControls extends StatelessWidget {
  final bool thereIsFile;
  final VoidCallback onDelete, onAdd;
  final VoidCallback? onLeft, onRight;

  const ImageControls({
    super.key,
    required this.thereIsFile,
    required this.onAdd,
    required this.onDelete,
    this.onLeft,
    this.onRight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (thereIsFile) ...[
          // delete
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: onDelete,
          ),

          // move
          if (onLeft != null && onRight != null) ...[
            IconButton(
              icon: const Icon(
                Icons.chevron_left,
              ),
              onPressed: onLeft,
            ),
            IconButton(
              icon: const Icon(
                Icons.chevron_right,
              ),
              onPressed: onRight,
            ),
          ],
        ] else ...[
          // add
          IconButton(
            icon: const Icon(
              Icons.add_a_photo,
            ),
            onPressed: onAdd,
          ),
        ],
      ],
    );
  }
}
