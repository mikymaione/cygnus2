/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:cygnus2/data_structures/mad_filter.dart';
import 'package:cygnus2/store/base_store.dart';
import 'package:cygnus2/store/firebase_tables.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class StoreMad extends BaseStore {
  //
  Future<String> addLike(String fromId, MadData m, bool like) async {
    if (like) {
      m.personWhoDislikeMe.remove(fromId);
      m.personWhoLikeMe.add(fromId);
    } else {
      m.personWhoLikeMe.remove(fromId);
      m.personWhoDislikeMe.add(fromId);
    }

    return await saveMad(m);
  }

  Future<String> saveMad(MadData m) => save(
        FirebaseTables.myself,
        m.idFirebase,
        m.toJson(),
      );

  Stream<bool> madExists(String? personId) {
    return FirebaseFirestore.instance
        .collection(
          FirebaseTables.myself.name,
        )
        .where(
          'personId',
          isEqualTo: personId,
        )
        .snapshots()
        .handleError(
          (e) => Commons.printIfInDebug('Error in "madExists": $e'),
        )
        .map(
          (json) => json.docs.isNotEmpty,
        );
  }

  Stream<MadData?> getMad(String? personId) {
    return FirebaseFirestore.instance
        .collection(
          FirebaseTables.myself.name,
        )
        .doc(personId)
        .snapshots()
        .handleError(
          (e) => Commons.printIfInDebug('Error in "getMad": $e'),
        )
        .map(
          (json) => MadData.fromNullableJson(json.id, json.data()),
        );
  }

  Stream<Iterable<MadData>> _allMads(String myId, GeoFirePoint myLocation, double radiusInKm) {
    return GeoCollectionReference<MadData>(
      FirebaseFirestore.instance
          .collection(
            FirebaseTables.myself.name,
          )
          .withConverter<MadData>(
            fromFirestore: (snapshot, options) => MadData.fromJson(snapshot.id, snapshot.data()!),
            toFirestore: (madData, options) => madData.toJson(),
          ),
    )
        .subscribeWithin(
          geopointFrom: (madData) => madData.geoPoint,
          center: myLocation,
          radiusInKm: radiusInKm,
          field: 'location',
          strictMode: true,
        )
        .handleError(
          (e) => Commons.printIfInDebug('Error in "_allMads": $e'),
        )
        .map(
          (docs) => docs
              .map(
                (doc) => doc.data(),
              )
              .whereNotNull()
              .where(
                (mad) => myId != mad.personId,
              ),
        );
  }

  Stream<Iterable<MadData>> _searchMads(String myId, MadFilter filter, GeoFirePoint myLocation, double radiusInKm) {
    return GeoCollectionReference<MadData>(
      FirebaseFirestore.instance
          .collection(
            FirebaseTables.myself.name,
          )
          .withConverter<MadData>(
            fromFirestore: (snapshot, options) => MadData.fromJson(snapshot.id, snapshot.data()!),
            toFirestore: (madData, options) => madData.toJson(),
          ),
    )
        .subscribeWithin(
          geopointFrom: (madData) => madData.geoPoint,
          center: myLocation,
          radiusInKm: radiusInKm,
          field: 'location',
          strictMode: true,
        )
        .handleError(
          (e) => Commons.printIfInDebug('Error in "_allMads": $e'),
        )
        .map(
          (docs) => docs
              .map(
                (doc) => doc.data(),
              )
              .whereNotNull()
              .where(
                (mad) => _filterMad(myId, mad, filter),
              ),
        );
  }

  bool _filterMad(String myId, MadData mad, MadFilter filter) => myId != mad.personId && filter.isInAgeRange(mad.age);

  Stream<Iterable<MadData>> searchMads(String? myId, MadFilter? filter, GeoFirePoint? myLocation, double radius) {
    if (myId == null || myLocation == null) {
      return const Stream<Iterable<MadData>>.empty();
    } else if (filter == null) {
      return _allMads(myId, myLocation, radius);
    } else {
      return _searchMads(myId, filter, myLocation, radius);
    }
  }
}
