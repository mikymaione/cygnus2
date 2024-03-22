/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:cygnus2/data_structures/blocked_data.dart';
import 'package:cygnus2/data_structures/chat_data.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_blocked.dart';
import 'package:cygnus2/store/store_messages.dart';
import 'package:cygnus2/ui/base/screen.dart';
import 'package:cygnus2/ui/chats/chat_message_bar.dart';
import 'package:cygnus2/data_structures/chats_data.dart';
import 'package:cygnus2/ui/base/msg.dart';

class Chat extends StatefulWidget {
  final ChatsData chatsData;
  final MyData myProfile;

  const Chat({
    super.key,
    required this.chatsData,
    required this.myProfile,
  });

  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final storeMessages = StoreMessages();
  final scrollController = ScrollController();
  final textBoxController = TextEditingController();

  late final chatBackgroundDark = Theme.of(context).primaryColorLight;

  late final chatBackgroundLight = Theme.of(context).primaryColorLight.withAlpha(50);

  @override
  void dispose() {
    scrollController.dispose();
    textBoxController.dispose();
    super.dispose();
  }

  Future<void> setBlock(bool blocked) async {
    final myId = widget.myProfile.profileData!.idFirebase;
    final id = widget.chatsData.interlocutorId(myId);
    final name = widget.chatsData.interlocutorName(myId);

    final canBlock = await Msg.ask(
      context: context,
      title: blocked ? 'Blocca' : 'Sblocca',
      text: blocked ? 'Sei sicuro di voler bloccare $name?' : 'Sei sicuro di voler sbloccare $name?',
    );

    if (true == canBlock) {
      try {
        if (blocked) {
          final b = Blocked(
            idFirebase: null,
            id1: myId,
            id2: id,
          );

          final storeBlocked = StoreBlocked();
          await storeBlocked.saveBlocked(b);
        } else {
          final blockedByMe = widget.myProfile.blockedByMe!.where(
            (b) => b.id2 == id,
          );

          for (final h in blockedByMe) {
            final b = Blocked(
              idFirebase: h.idFirebase,
              id1: myId,
              id2: '',
            );

            final storeBlocked = StoreBlocked();
            await storeBlocked.saveBlocked(b);
          }
        }

        if (mounted) {
          Navigator.pop(context);
          Msg.showOk(context, blocked ? '$name è stato bloccato' : '$name è stato sbloccato');
        }
      } catch (e) {
        if (mounted) {
          Msg.showError(context, e);
        }
      }
    }
  }

  Future<void> send() async {
    final text = textBoxController.text;

    if (text.trim().isNotEmpty) {
      textBoxController.text = '';

      try {
        final chatId = widget.chatsData.idFirebase!;

        final m = ChatData(
          idFirebase: null,
          chatId: chatId,
          senderId: widget.myProfile.profileData!.idFirebase,
          text: text,
          data: DateTime.now(),
        );

        await storeMessages.saveMessage(chatId, m);

        storeMessages.updateChat(widget.chatsData.idFirebase!, text);
      } catch (e) {
        if (mounted) {
          Msg.showError(context, e);
        }
      }
    }
  }

  SplayTreeMap<int, X> iterableToMap<X>(Iterable<X>? items) {
    final m = SplayTreeMap<int, X>();

    if (items != null) {
      var i = 0;

      for (final e in items) {
        m[i] = e;
        i++;
      }
    }

    return m;
  }

  bool get userIsBlocked => widget.myProfile.idsBlocked.contains(widget.chatsData.interlocutorId(widget.myProfile.profileData?.idFirebase));

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final interlocutorName = widget.chatsData.interlocutorName(widget.myProfile.profileData?.idFirebase);

    return Screen(
      title: interlocutorName,
      actions: [
        if (userIsBlocked) ...[
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Sblocca $interlocutorName',
            onPressed: () async => await setBlock(false),
          ),
        ] else ...[
          IconButton(
            icon: const Icon(Icons.person_remove),
            tooltip: 'Blocca $interlocutorName',
            onPressed: () async => await setBlock(true),
          ),
        ],
      ],
      body: StreamBuilder<Iterable<ChatData>>(
        stream: storeMessages.loadChatContent(widget.chatsData.idFirebase!),
        builder: (context, snapshot) {
          final data = iterableToMap<ChatData>(snapshot.data);

          return Column(
            children: [
              // chat content
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: scrollController,
                  child: ListView.builder(
                    controller: scrollController,
                    reverse: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final chat = data[index]!;

                      return Row(
                        children: [
                          // space on left
                          if (chat.isMine(widget.myProfile.profileData?.idFirebase)) ...[
                            Flexible(
                              flex: 1,
                              child: Container(),
                            ),
                          ],

                          Flexible(
                            flex: 5,
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: chat.isMine(widget.myProfile.profileData?.idFirebase) ? chatBackgroundDark : chatBackgroundLight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // text message
                                    Text(
                                      chat.text,
                                      textAlign: TextAlign.justify,
                                    ),

                                    const SizedBox(height: 6),

                                    // date
                                    Row(
                                      children: [
                                        const Spacer(),
                                        Text(
                                          chat.dateFullSec(languageCode),
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // space on right
                          if (!chat.isMine(widget.myProfile.profileData?.idFirebase)) ...[
                            Flexible(
                              flex: 1,
                              child: Container(),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),

              // text box
              if (!userIsBlocked) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  child: ChatMessageBar(
                    textBoxController: textBoxController,
                    onSend: () => send(),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
