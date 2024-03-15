/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cygnus2/store/firebase_tables.dart';

abstract class BaseStore {
  Future<void> delete(FirebaseTables table, String idFirebase) => FirebaseFirestore.instance
      .collection(
        table.name,
      )
      .doc(idFirebase)
      .delete();

  Future<String> save(FirebaseTables table, String? idFirebase, Map<String, dynamic> json, {bool merge = false}) async {
    final collection = table.name;
    if (kDebugMode) {
      print('Firestore Adding in "$collection": $json');
    }

    try {
      if (idFirebase == null) {
        final R = await FirebaseFirestore.instance.collection(collection).add(json);

        if (kDebugMode) {
          print('Firestore Add in "$collection": $json');
        }

        return R.id;
      } else {
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(
              idFirebase,
            )
            .set(
              json,
              SetOptions(merge: merge),
            );

        if (kDebugMode) {
          print('Firestore Set in "$collection": $json');
        }

        return idFirebase;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firestore Save Error: $e');
      }
      rethrow;
    }
  }
}
