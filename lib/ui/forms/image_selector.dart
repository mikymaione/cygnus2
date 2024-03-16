/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'dart:convert';

import 'package:cygnus2/data_structures/image_data.dart';
import 'package:cygnus2/store/store_images.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/utility/loading_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as fx;
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  final String idFirebaseMad;
  final ImageData? imageData;

  const ImageSelector({
    super.key,
    required this.idFirebaseMad,
    required this.imageData,
  });

  @override
  State<StatefulWidget> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  final storeImages = StoreImages();

  Future<void> remove() async {
    try {
      if (widget.imageData?.idFirebase != null) {
        await storeImages.deleteImage(widget.idFirebaseMad, widget.imageData!.idFirebase!);
      }
    } catch (e) {
      if (mounted) {
        Msg.showError(context, e);
      }
    }
  }

  Future<void> select() async {
    final overlay = LoadingOverlay(context: context);
    overlay.show();

    try {
      final imagePicker = ImagePicker();

      final imageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (imageFile == null) {
        overlay.hide();
      } else {
        final imageFileBytes = await imageFile.readAsBytes();

        final image = fx.decodeImage(imageFileBytes);

        if (image != null) {
          final isLandscape = image.width > image.height;
          final isPortrait = image.width < image.height;
          final isSquare = image.width == image.height;

          final resizedImage = fx.copyResize(
            image,
            width: isLandscape || isSquare ? 500 : null,
            height: isPortrait || isSquare ? 500 : null,
            maintainAspect: true,
          );

          final jpgImageBytes = fx.encodeJpg(
            resizedImage,
            quality: 90,
          );

          final base64Image = base64Encode(jpgImageBytes);

          final i = ImageData(
            idFirebase: widget.imageData?.idFirebase,
            base64Image: base64Image,
          );

          await storeImages.saveImage(widget.idFirebaseMad, i);

          overlay.hide();
        }
      }
    } catch (e) {
      overlay.hide();

      if (mounted) {
        Msg.showError(context, e);
      }
    }
  }

  Uint8List? getImage() {
    try {
      if (widget.imageData != null) {
        return base64Decode(widget.imageData!.base64Image);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bytes = getImage();

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
        ),
        margin: const EdgeInsets.all(8),
        child: Stack(
          children: [
            if (bytes == null) ...[
              IconButton(
                icon: const Icon(
                  Icons.add_a_photo,
                ),
                onPressed: () => select(),
              ),
            ] else ...[
              Center(
                child: Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => remove(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
