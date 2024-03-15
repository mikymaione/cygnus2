/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_mad.dart';
import 'package:cygnus2/store/store_messages.dart';
import 'package:cygnus2/ui/base/no_element.dart';
import 'package:cygnus2/ui/chats/chat.dart';
import 'package:cygnus2/data_structures/chats_data.dart';
import 'package:cygnus2/utility/commons.dart';

class Chats extends StatefulWidget {
  final MyData? myProfile;

  const Chats({
    super.key,
    required this.myProfile,
  });

  @override
  State<StatefulWidget> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final storeMessages = StoreMessages();
  final storeMads = StoreMad();
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return StreamBuilder<Iterable<ChatsData>>(
      stream: storeMessages.loadMyChats(widget.myProfile?.profileData.idFirebase),
      builder: (context, snapChats) {
        final items = snapChats.data?.toList(growable: false) ?? const <ChatsData>[];
        final count = snapChats.data?.length ?? 0;

        return count == 0
            ? const NoElement(
                icon: Icons.message,
                iconColor: Colors.green,
                message: 'Non hai ancora conversato con nessun utente.',
              )
            : Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final chat = items[index];

                    return Card(
                      child: InkWell(
                        onTap: () => Commons.navigate(
                          context: context,
                          builder: (context) => Chat(
                            chatsData: chat,
                            myProfile: widget.myProfile!,
                          ),
                        ),
                        child: ListTile(
                          leading: ProfilePicture(
                            name: chat.interlocutorName(widget.myProfile!.profileData.idFirebase),
                            radius: 24,
                            fontsize: 16,
                          ),
                          title: Text(chat.interlocutorName(widget.myProfile!.profileData.idFirebase)),
                          subtitle: Text(
                            chat.info(languageCode),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
