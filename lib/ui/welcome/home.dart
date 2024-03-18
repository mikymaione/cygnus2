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
import 'package:cygnus2/ui/mad/mad_filter.dart';
import 'package:cygnus2/ui/mad/mad_list.dart';
import 'package:cygnus2/ui/profile/settings.dart';
import 'package:cygnus2/ui/stats/stats.dart';
import 'package:cygnus2/utility/generic_controller.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final MyData myProfile; // for loading reason
  final String myName;

  const MyHomePage({
    super.key,
    required this.myName,
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

  Future<bool> _onWillPop() async => false;

  final filters = GenericController<MadFilter>();

  late final storePushNotifications = StorePushNotifications(
    getContext: () => context,
  );

  int get tabs => 5;

  String get title => currentTab.label;

  bool get showTabsLabel => MediaQuery.of(context).size.width > 490;

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
  void dispose() {
    filters.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: DefaultTabController(
        length: tabs,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(title),
            bottom: TabBar(
              onTap: (index) => setState(() => currentTab = tabByIndex(index)),
              tabs: [
                Tab(
                  icon: const Icon(Icons.explore),
                  text: showTabsLabel ? _TabsName.explore.label : null,
                ),
                Tab(
                  icon: const Icon(Icons.chat),
                  text: showTabsLabel ? _TabsName.chats.label : null,
                ),
                Tab(
                  icon: const Icon(Icons.badge),
                  text: showTabsLabel ? _TabsName.profile.label : null,
                ),
                Tab(
                  icon: const Icon(Icons.area_chart),
                  text: showTabsLabel ? _TabsName.stats.label : null,
                ),
                Tab(
                  icon: const Icon(Icons.settings),
                  text: showTabsLabel ? _TabsName.settings.label : null,
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // list of profiles in system
              MadList(
                myProfile: widget.myProfile,
                myName: widget.myName,
                filters: filters,
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
