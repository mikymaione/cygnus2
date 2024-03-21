/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/data_structures/chats_data.dart';
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_messages.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/ui/base/screen.dart';
import 'package:cygnus2/ui/chats/chat.dart';
import 'package:cygnus2/ui/mad/mad_crud.dart';
import 'package:cygnus2/ui/mad/profile_pictures.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:flutter/material.dart';

class MadScreen extends StatefulWidget {
  final MyData myProfile;
  final MadData mad;

  const MadScreen({
    super.key,
    required this.mad,
    required this.myProfile,
  });

  @override
  State<MadScreen> createState() => _MadScreenState();
}

class _MadScreenState extends State<MadScreen> {
  final scrollController = ScrollController();

  bool get userIsBlocked => widget.myProfile.idsBlocked.contains(widget.mad.personId);

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> messageWith() async {
    final store = StoreMessages();

    final existingChat = await store.findChat(widget.myProfile.profileData!.idFirebase, widget.mad.personId);

    Commons.printIfInDebug('findChat(${widget.myProfile.profileData!.idFirebase}, ${widget.mad.personId}): ${existingChat?.idFirebase}');

    if (existingChat == null) {
      // new
      final chatsData = ChatsData(
        idFirebase: null,
        created: DateTime.now(),
        interlocutorsIds: {
          widget.myProfile.profileData!.idFirebase,
          widget.mad.personId,
        },
        interlocutorsIdsMap: {
          widget.myProfile.profileData!.idFirebase: true,
          widget.mad.personId: true,
        },
        interlocutors: {
          widget.myProfile.profileData!.idFirebase: widget.myProfile.madData!.nickname,
          widget.mad.personId: widget.mad.nickname,
        },
        lastMessageText: '',
        lastMessageData: DateTime.now(),
      );

      chatsData.idFirebase = await store.saveChat(chatsData);

      if (mounted) {
        Commons.navigate(
          context: context,
          builder: (context) => Chat(
            chatsData: chatsData,
            myProfile: widget.myProfile,
          ),
        );
      }
    } else {
      if (mounted) {
        Commons.navigate(
          context: context,
          builder: (context) => Chat(
            chatsData: existingChat,
            myProfile: widget.myProfile,
          ),
        );
      }
    }
  }

  Future<void> askToContact() async {
    if (userIsBlocked) {
      await Msg.say(
        context: context,
        title: 'Contatta',
        text: 'Non puoi contattare ${widget.mad.nickname} perché è bloccato',
      );
    } else {
      final ok = await Msg.ask(
        context: context,
        title: 'Contatta',
        text: 'Sei sicuro di voler contattare ${widget.mad.nickname}?',
      );

      if (ok) {
        await messageWith();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: widget.mad.nickname,
      actions: [
        IconButton(
          icon: const Icon(Icons.message),
          tooltip: 'Contatta',
          onPressed: () => askToContact(),
        ),
      ],
      body: Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // images
                ProfilePictures(
                  readOnly: true,
                  idProfile: widget.mad.personId,
                ),

                // data
                MadCrud(
                  readOnly: true,
                  myProfile: widget.myProfile,
                  mad: widget.mad,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
