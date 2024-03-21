/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/store/store_images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class MyProfilePicture extends StatefulWidget {
  final String personId;
  final String nickname;
  final double? size;

  const MyProfilePicture({
    super.key,
    required this.personId,
    required this.nickname,
    this.size,
  });

  @override
  State<MyProfilePicture> createState() => _MyProfilePictureState();
}

class _MyProfilePictureState extends State<MyProfilePicture> {
  final storeImages = StoreImages();

  @override
  Widget build(BuildContext context) {
    // Initials or 1 image
    return FutureBuilder<Uint8List?>(
      future: storeImages.getImage1(widget.personId),
      initialData: storeImages.getImage1Mem(widget.personId),
      builder: (context, snapImage1) => snapImage1.hasData && snapImage1.requireData != null
          ? SizedBox(
              width: widget.size,
              height: widget.size,
              child: Image.memory(
                snapImage1.requireData!,
                fit: BoxFit.contain,
              ),
            )
          : ProfilePicture(
              name: widget.nickname,
              radius: 24,
              fontsize: 16,
            ),
    );
  }
}
