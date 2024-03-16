/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/data_structures/image_data.dart';
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_images.dart';
import 'package:cygnus2/store/store_mad.dart';
import 'package:cygnus2/ui/mad/mad_crud.dart';
import 'package:flutter/material.dart';

class MadContainer extends StatefulWidget {
  final bool readOnly, showSendMsgButton;
  final MyData? myProfile;

  const MadContainer({
    super.key,
    required this.readOnly,
    required this.showSendMsgButton,
    required this.myProfile,
  });

  @override
  State<StatefulWidget> createState() => _MadContainerState();
}

class _MadContainerState extends State<MadContainer> {
  final storeImages = StoreImages();
  final storeMad = StoreMad();

  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<MadData?>(
            stream: storeMad.getMad(widget.myProfile!.profileData.idFirebase),
            builder: (context, snapMad) => StreamBuilder<Iterable<ImageData>>(
              stream: storeImages.getImages(widget.myProfile!.profileData.idFirebase),
              builder: (context, snapImages) => snapMad.hasData && snapMad.requireData != null && snapImages.hasData
                  ? MadCrud(
                      readOnly: widget.readOnly,
                      showSendMsgButton: widget.showSendMsgButton,
                      myProfile: widget.myProfile!,
                      images: snapImages.requireData.toList(),
                      mad: snapMad.requireData!,
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
