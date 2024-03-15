/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:cygnus2/store/base_store.dart';
import 'package:cygnus2/store/firebase_tables.dart';
import 'package:cygnus2/ui/mad/mad_filter.dart';
import 'package:cygnus2/utility/commons.dart';

class StoreMad extends BaseStore {
  //
  Future<void> deleteMad(String idFirebase) => delete(FirebaseTables.myself, idFirebase);

  Future<String> saveMad(MadData m) => save(
        FirebaseTables.myself,
        m.idFirebase,
        m.toJson(),
      );

  Stream<Iterable<MadData>> getMad(String personId) {
    return FirebaseFirestore.instance
        .collection(
          FirebaseTables.myself.name,
        )
        .limit(1)
        .snapshots()
        .map(
          (ref) => ref.docs.map(
            (json) => MadData.fromJson(json.id, json.data()),
          ),
        );
  }

  Stream<Iterable<MadData>> _first10Mads(String myId) {
    return FirebaseFirestore.instance
        .collection(
          FirebaseTables.myself.name,
        )
        .limit(10)
        .snapshots()
        .handleError(
          (e) => Commons.printIfInDebug('Error in "_first10Mads": $e'),
        )
        .map(
          (ref) => ref.docs
              .map(
                (json) => MadData.fromJson(json.id, json.data()),
              )
              .where(
                (mad) => mad.personId != myId,
              ),
        );
  }

  Stream<Iterable<MadData>> _searchMads(String myId, MadFilter filter) {
    return FirebaseFirestore.instance
        .collection(
          FirebaseTables.myself.name,
        )
        .where(
          'whereProvinceCitiesName',
          arrayContains: filter.city,
        )
        .limit(filter.noFilterSet ? 10 : 50)
        .snapshots()
        .handleError(
          (e) => Commons.printIfInDebug('Error in "_searchMadsByProvince": $e'),
        )
        .map(
          (ref) => ref.docs.map(
            (json) => MadData.fromJson(json.id, json.data()),
          ),
        );
  }

  Stream<Iterable<MadData>> searchMads(String? myId, MadFilter? filter) {
    if (myId == null) {
      return const Stream<Iterable<MadData>>.empty();
    } else if (filter == null) {
      return _first10Mads(myId);
    } else {
      return _searchMads(myId, filter);
    }
  }

  Stream<Iterable<MadData>> loadMyMads(String? myId) {
    return myId == null
        ? const Stream<Iterable<MadData>>.empty()
        : FirebaseFirestore.instance
            .collection(
              FirebaseTables.myself.name,
            )
            .snapshots()
            .map(
              (ref) => ref.docs.map(
                (json) => MadData.fromJson(json.id, json.data()),
              ),
            );
  }
}
