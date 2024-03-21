/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/data_structures/image_data.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_images.dart';
import 'package:cygnus2/ui/forms/image_selector.dart';
import 'package:flutter/widgets.dart';

class ProfilePictures extends StatefulWidget {
  final MyData myProfile;

  const ProfilePictures({
    super.key,
    required this.myProfile,
  });

  @override
  State<StatefulWidget> createState() => _ProfilePicturesState();
}

class _ProfilePicturesState extends State<ProfilePictures> {
  final storeImages = StoreImages();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ImageData>>(
      stream: storeImages.getImages(widget.myProfile.profileData?.idFirebase),
      builder: (context, snapImages) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var y = 0; y < 2; y++) ...[
            Row(
              children: [
                for (var x = y * 3; x < 3 + (y * 3); x++) ...[
                  Expanded(
                    child: ImageSelector(
                      idFirebaseMad: widget.myProfile.profileData!.idFirebase,
                      imageData: x < (snapImages.data?.length ?? 0) ? snapImages.data?.elementAt(x) : null,
                      index: x,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
