/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cygnus2/data_structures/chat_data.dart';
import 'package:cygnus2/store/base_store.dart';
import 'package:cygnus2/store/firebase_tables.dart';
import 'package:cygnus2/data_structures/chats_data.dart';

class StoreMessages extends BaseStore {
  //
  Future<void> deleteMyChats(String myId) async {
    final ref = await FirebaseFirestore.instance
        .collection(FirebaseTables.chat.name)
        .where(
          'interlocutorsIds',
          arrayContains: myId,
        )
        .get();

    final ids = ref.docs.map((d) => d.id);

    for (final id in ids) {
      await FirebaseFirestore.instance.collection(FirebaseTables.chat.name).doc(id).delete();
    }
  }

  Future<String> updateChat(String idFirebase, String lastMessageText) => save(
        FirebaseTables.chat,
        idFirebase,
        {
          'lastMessageText': lastMessageText,
          'lastMessageData': DateTime.now().toIso8601String(),
        },
        merge: true,
      );

  Future<String> saveChat(ChatsData m) => save(
        FirebaseTables.chat,
        m.idFirebase,
        m.toJson(),
      );

  Stream<Iterable<ChatsData>> loadMyChats(String? myId) {
    return myId == null
        ? const Stream<Iterable<ChatsData>>.empty()
        : FirebaseFirestore.instance
            .collection(FirebaseTables.chat.name)
            .where(
              'interlocutorsIds',
              arrayContains: myId,
            )
            .orderBy(
              'lastMessageData',
              descending: true,
            )
            .snapshots()
            .map(
              (ref) => ref.docs.map(
                (json) => ChatsData.fromJson(json.id, json.data()),
              ),
            );
  }

  Future<ChatsData?> findChat(String? myId, String interlocutor) async {
    final ref = await FirebaseFirestore.instance
        .collection(FirebaseTables.chat.name)
        .where(
          'interlocutorsIdsMap.$myId',
          isEqualTo: true,
        )
        .where(
          'interlocutorsIdsMap.$interlocutor',
          isEqualTo: true,
        )
        .limit(1)
        .get();

    return ref.docs
        .map(
          (json) => ChatsData.fromJson(json.id, json.data()),
        )
        .firstOrNull;
  }

  // messages
  Future<String> saveMessage(String chatId, ChatData m) => save2(
        FirebaseFirestore.instance
            .collection(
              FirebaseTables.chat.name,
            )
            .doc(chatId)
            .collection(
              FirebaseTables.message.name,
            ),
        m.idFirebase,
        m.toJson(),
      );

  Stream<Iterable<ChatData>> loadChatContent(String chatId) {
    return FirebaseFirestore.instance
        .collection(
          FirebaseTables.chat.name,
        )
        .doc(chatId)
        .collection(
          FirebaseTables.message.name,
        )
        .orderBy(
          'data',
          descending: true,
        )
        .snapshots()
        .map(
          (ref) => ref.docs.map(
            (json) => ChatData.fromJson(json.id, json.data()),
          ),
        );
  }
}
