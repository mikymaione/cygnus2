/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_push_notifications.dart';
import 'package:cygnus2/ui/chats/chats.dart';
import 'package:cygnus2/ui/mad/mad_container.dart';
import 'package:cygnus2/ui/mad/mad_list_filtered.dart';
import 'package:cygnus2/ui/profile/settings.dart';
import 'package:cygnus2/ui/stats/stats.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final MyData myProfile; // for loading reason

  const MyHomePage({
    super.key,
    required this.myProfile,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum _TabsName {
  stats,
  explore,
  profile,
  chats,
  settings,
}

extension _TabsNameNameExtension on _TabsName {
  String get label => switch (this) {
        _TabsName.stats => "Statistiche",
        _TabsName.explore => "Esplora",
        _TabsName.profile => "Profilo",
        _TabsName.chats => "Chat",
        _TabsName.settings => "Impostazioni",
      };
}

class _MyHomePageState extends State<MyHomePage> {
  var currentTab = _TabsName.explore;

  late final storePushNotifications = StorePushNotifications(
    getContext: () => context,
  );

  int get tabs => 5;

  String get title => currentTab.label;

  _TabsName tabByIndex(int i) => switch (i) {
        0 => _TabsName.explore,
        1 => _TabsName.chats,
        2 => _TabsName.profile,
        3 => _TabsName.stats,
        4 => _TabsName.settings,
        _ => throw UnimplementedError(),
      };

  @override
  void initState() {
    super.initState();
    storePushNotifications.init();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DefaultTabController(
        length: tabs,
        child: Scaffold(
          appBar: TabBar(
            onTap: (index) => setState(() => currentTab = tabByIndex(index)),
            tabs: [
              Tab(
                icon: const Icon(Icons.explore),
                text: _TabsName.explore.label,
              ),
              Tab(
                icon: const Icon(Icons.chat),
                text: _TabsName.chats.label,
              ),
              Tab(
                icon: const Icon(Icons.badge),
                text: _TabsName.profile.label,
              ),
              Tab(
                icon: const Icon(Icons.area_chart),
                text: _TabsName.stats.label,
              ),
              Tab(
                icon: const Icon(Icons.settings),
                text: _TabsName.settings.label,
              ),
            ],
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // list of profiles in system
              MadListFiltered(
                myProfile: widget.myProfile,
              ),

              // my chats
              Chats(myProfile: widget.myProfile),

              // my profile
              MadContainer(
                myProfile: widget.myProfile,
                readOnly: false,
                showSendMsgButton: false,
              ),

              // Stats
              const Stats(),

              // my settings
              Settings(myProfile: widget.myProfile),
            ],
          ),
        ),
      ),
    );
  }
}
