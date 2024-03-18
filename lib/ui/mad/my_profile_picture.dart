/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'dart:convert';

import 'package:cygnus2/data_structures/image_data.dart';
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class MyProfilePicture extends StatelessWidget {
  final MadData mad;
  final ImageData? imageData;

  const MyProfilePicture({
    super.key,
    required this.mad,
    required this.imageData,
  });

  @override
  Widget build(BuildContext context) {
    // Initials or 1 image
    return imageData == null
        ? ProfilePicture(
            name: mad.nickname,
            radius: 24,
            fontsize: 16,
          )
        : SizedBox(
            width: 100,
            height: 100,
            child: Image.memory(
              base64Decode(imageData!.base64Image),
              fit: BoxFit.contain,
            ),
          );
  }
}
