/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cygnus2/data_structures/stat_data.dart';
import 'package:cygnus2/store/firebase_tables.dart';
import 'package:cygnus2/utility/commons.dart';

abstract class BaseStore {
  Future<void> delete(FirebaseTables table, String idFirebase) => delete2(
        FirebaseFirestore.instance.collection(table.name),
        idFirebase,
      );

  Future<void> delete2(CollectionReference collection, String idFirebase) async {
    final collectionName = collection.id;

    try {
      // delete entity
      await collection.doc(idFirebase).delete();

      // delete stat
      if (collectionName != FirebaseTables.stats.name) {
        Commons.printIfInDebug('Updating stats...');

        await delete(FirebaseTables.stats, idFirebase);
      }
    } catch (e) {
      Commons.printIfInDebug('Firestore Delete Error: $e');
      rethrow;
    }
  }

  Future<String> save(FirebaseTables table, String? idFirebase, Map<String, dynamic> json, {bool merge = false}) {
    final tableName = table.name;
    final collection = FirebaseFirestore.instance.collection(tableName);

    return save2(
      collection,
      idFirebase,
      json,
      merge: merge,
    );
  }

  Future<String> save2(CollectionReference collection, String? idFirebase, Map<String, dynamic> json, {bool merge = false}) async {
    final collectionName = collection.id;

    Commons.printIfInDebug('Firestore Adding in "$collectionName": $json');

    try {
      if (idFirebase == null) {
        final R = await collection.add(json);

        Commons.printIfInDebug('Firestore Add in "$collectionName": $json');

        if (collectionName != FirebaseTables.stats.name) {
          Commons.printIfInDebug('Updating stats...');

          final s = StatData(
            idFirebase: R.id,
            name: collectionName,
            data: DateTime.now(),
          );

          await save(FirebaseTables.stats, s.idFirebase, s.toJson());
        }

        return R.id;
      } else {
        await collection
            .doc(
              idFirebase,
            )
            .set(
              json,
              SetOptions(merge: merge),
            );

        Commons.printIfInDebug('Firestore Set in "$collectionName": $json');

        return idFirebase;
      }
    } catch (e) {
      Commons.printIfInDebug('Firestore Save Error: $e');
      rethrow;
    }
  }
}
