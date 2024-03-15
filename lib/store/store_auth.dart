/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cygnus2/data_structures/profile_data.dart';
import 'package:cygnus2/store/base_store.dart';
import 'package:cygnus2/store/firebase_tables.dart';
import 'package:cygnus2/store/store_mad.dart';

class StoreAuth extends BaseStore {
  //

  User? get currentUser => FirebaseAuth.instance.currentUser;

  Stream<User?> currentAuthentication() => FirebaseAuth.instance.userChanges();

  Future<void> logout() => FirebaseAuth.instance.signOut();

  Future<int> deleteProfile(String myId) async {
    var x = 0;

    final storeMad = StoreMad();
    final mads = await storeMad.loadMyMads(myId).toList();

    for (final items in mads) {
      for (final m in items) {
        await storeMad.deleteMad(m.idFirebase!);
        x++;
      }
    }

    await delete(FirebaseTables.profile, myId);

    await FirebaseAuth.instance.currentUser?.delete();

    return x;
  }

  Future<String> saveProfile(ProfileData m) => save(
        FirebaseTables.profile,
        m.idFirebase,
        m.toJson(),
      );

  Stream<ProfileData> loadMyProfile(String myId) {
    return FirebaseFirestore.instance
        .collection(
          FirebaseTables.profile.name,
        )
        .doc(myId)
        .snapshots()
        .where(
          (json) => json.data() != null,
        )
        .map(
          (json) => ProfileData.fromJson(json.id, json.data()!),
        );
  }

  Future<ProfileData?> getMyProfile(String myId) async {
    final json = await FirebaseFirestore.instance
        .collection(
          FirebaseTables.profile.name,
        )
        .doc(myId)
        .get();

    final data = json.data();

    return data == null ? null : ProfileData.fromJson(json.id, json.data()!);
  }

  Future<void> sendPasswordResetEmail(String email) => FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

  Future<User?> login(String email, String password) async {
    final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

  Future<User?> createUser(String email, String password) async {
    final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }
}
