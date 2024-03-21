/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/data_structures/blocked_data.dart';
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:cygnus2/data_structures/mad_filter.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/data_structures/profile_data.dart';
import 'package:cygnus2/store/store_auth.dart';
import 'package:cygnus2/store/store_blocked.dart';
import 'package:cygnus2/store/store_filter.dart';
import 'package:cygnus2/store/store_mad.dart';
import 'package:cygnus2/ui/welcome/home.dart';
import 'package:cygnus2/ui/welcome/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Cygnus2 extends StatefulWidget {
  const Cygnus2({super.key});

  @override
  State<Cygnus2> createState() => _Cygnus2State();
}

class _Cygnus2State extends State<Cygnus2> {
  @override
  Widget build(BuildContext context) {
    final storeAuth = StoreAuth();
    final storeMad = StoreMad();
    final storeFilter = StoreFilter();
    final storeBlocked = StoreBlocked();

    return StreamBuilder<User?>(
      stream: storeAuth.currentAuthentication(),
      builder: (context, snapAuth) => MaterialApp(
        title: 'Cygnus2',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('it'),
        ],
        themeMode: ThemeMode.system,
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: storeAuth.currentUser == null && snapAuth.data == null
            ? const Welcome()
            : StreamBuilder<ProfileData>(
                stream: storeAuth.loadMyProfile(storeAuth.currentUser?.uid ?? snapAuth.requireData!.uid),
                builder: (context, snapProfile) => StreamBuilder<Iterable<Blocked>>(
                  stream: storeBlocked.loadBlockedByMe(snapProfile.data?.idFirebase),
                  builder: (context, snapBlockedByMe) => StreamBuilder<Iterable<Blocked>>(
                    stream: storeBlocked.loadHaveBlockedMe(snapProfile.data?.idFirebase),
                    builder: (context, snapHaveBlockedMe) => StreamBuilder<MadData?>(
                      stream: storeMad.getMad(snapProfile.data?.idFirebase),
                      builder: (context, snapMyMad) => StreamBuilder<MadFilter?>(
                        stream: storeFilter.getFilter(snapProfile.data?.idFirebase),
                        builder: (context, snapFilter) => MyHomePage(
                          myProfile: MyData(
                            madData: snapMyMad.data,
                            filters: snapFilter.data,
                            profileData: snapProfile.data,
                            blockedByMe: snapBlockedByMe.data,
                            blockedMe: snapHaveBlockedMe.data,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
