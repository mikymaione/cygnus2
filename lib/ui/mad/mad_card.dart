/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_messages.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/ui/chats/chat.dart';
import 'package:cygnus2/data_structures/chats_data.dart';
import 'package:cygnus2/ui/mad/icon_chip.dart';
import 'package:cygnus2/utility/commons.dart';

class MadCard extends StatefulWidget {
  final MyData myProfile;
  final MadData mad;
  final GestureTapCallback? onTap;

  const MadCard({
    super.key,
    required this.mad,
    required this.onTap,
    required this.myProfile,
  });

  @override
  State<StatefulWidget> createState() => _MadCardState();
}

class _MadCardState extends State<MadCard> {
  Future<void> messageWith(BuildContext context) async {
    final store = StoreMessages();

    final existingChat = await store.findChat(widget.myProfile.profileData.idFirebase, widget.mad.personId);

    if (kDebugMode) {
      print('findChat(${widget.myProfile.profileData.idFirebase}, ${widget.mad.personId}): ${existingChat?.idFirebase}');
    }

    if (existingChat == null) {
      // new
      final chatsData = ChatsData(
        idFirebase: null,
        created: DateTime.now(),
        interlocutorsIds: {
          widget.myProfile.profileData.idFirebase,
          widget.mad.personId,
        },
        interlocutorsIdsMap: {
          widget.myProfile.profileData.idFirebase: true,
          widget.mad.personId: true,
        },
        interlocutors: {
          widget.myProfile.profileData.idFirebase: widget.myProfile.profileData.displayName,
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

  Future<void> askToContact(BuildContext context) async {
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
        if (mounted) {
          await messageWith(context);
        }
      }
    }
  }

  bool get userIsBlocked => true == widget.myProfile.idsBlocked.contains(widget.mad.personId);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          if (widget.onTap == null) {
            await askToContact(context);
          } else {
            widget.onTap!.call();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Initials
              ProfilePicture(
                name: widget.mad.nickname,
                radius: 24,
                fontsize: 16,
              ),

              // space
              const SizedBox(width: 8),

              // data
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nickname
                    Text(
                      widget.mad.nickname,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // space
                    const SizedBox(height: 8),

                    // Age
                    IconChip(
                      icon: Icons.cake,
                      color: Colors.blue,
                      labels: [widget.mad.ageS],
                    ),

                    // space
                    const SizedBox(height: 8),

                    // University
                    IconChip(
                      icon: Icons.balance,
                      color: Colors.amber,
                      labels: [widget.mad.university],
                    ),

                    // space
                    const SizedBox(height: 8),

                    // Department
                    IconChip(
                      icon: Icons.school,
                      color: Colors.brown,
                      labels: [widget.mad.department],
                    ),

                    // space
                    const SizedBox(height: 8),

                    // Location
                    IconChip(
                      icon: Icons.location_pin,
                      color: Colors.red,
                      labels: widget.mad.whereProvince.toList() + widget.mad.whereCitiesOnlyName.toList(),
                    ),

                    // space
                    const SizedBox(height: 8),

                    // Bio
                    IconChip(
                      icon: Icons.book,
                      color: Colors.green,
                      labels: [widget.mad.bio ?? ''],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
