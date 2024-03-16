/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cygnus2/data_structures/image_data.dart';
import 'package:cygnus2/store/base_store.dart';
import 'package:cygnus2/store/firebase_tables.dart';
import 'package:cygnus2/utility/commons.dart';

class StoreImages extends BaseStore {
  //
  Future<void> deleteImage(String idFirebaseMad, String idFirebase) => delete2(
        FirebaseFirestore.instance
            .collection(
              FirebaseTables.myself.name,
            )
            .doc(idFirebaseMad)
            .collection(
              FirebaseTables.image.name,
            ),
        idFirebase,
      );

  Future<String> saveImage(String idFirebaseMad, ImageData i) => save2(
        FirebaseFirestore.instance
            .collection(
              FirebaseTables.myself.name,
            )
            .doc(idFirebaseMad)
            .collection(
              FirebaseTables.image.name,
            ),
        i.idFirebase,
        i.toJson(),
      );

  Stream<Iterable<ImageData>> getImages(String? idFirebaseMad) {
    return FirebaseFirestore.instance
        .collection(
          FirebaseTables.myself.name,
        )
        .doc(idFirebaseMad)
        .collection(
          FirebaseTables.image.name,
        )
        .limit(6)
        .snapshots()
        .handleError(
          (e) => Commons.printIfInDebug('Error in "getImages": $e'),
        )
        .map(
          (ref) => ref.docs.map(
            (json) => ImageData.fromJson(json.id, json.data()),
          ),
        );
  }
}