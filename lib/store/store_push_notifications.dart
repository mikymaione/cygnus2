/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'dart:async';

import 'package:cygnus2/ui/cygnus2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:cygnus2/store/base_store.dart';
import 'package:cygnus2/store/firebase_tables.dart';
import 'package:cygnus2/store/store_auth.dart';
import 'package:cygnus2/ui/base/msg.dart';
import 'package:cygnus2/utility/commons.dart';

typedef ContextCallback = BuildContext Function();

class StorePushNotifications extends BaseStore {
  late final StreamSubscription _onNewToken, _onNotificationTap;

  final _storeAuth = StoreAuth();

  final ContextCallback getContext;

  StorePushNotifications({required this.getContext});

  Future<void> logout() async {
    if (!kIsWeb) {
      final userId = _storeAuth.currentUser?.uid;

      if (userId == null) {
        _showError('Can not delete Push Notification token because "UserID" is null');
      } else {
        await delete(FirebaseTables.tokens, userId);
      }
    }
  }

  Future<void> init() async {
    if (!kIsWeb) {
      try {
        final settings = await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        switch (settings.authorizationStatus) {
          case AuthorizationStatus.denied:
          case AuthorizationStatus.notDetermined:
            _showError('Push Notification will not work without: Alert, Badge and Sound permissions');
            break;

          case AuthorizationStatus.authorized:
          case AuthorizationStatus.provisional:
            Commons.printIfInDebug('Push Notification, user granted permission: ${settings.authorizationStatus}');

            final newToken = await FirebaseMessaging.instance.getToken();

            await _saveToken(newToken);

            // Note: This callback is fired at each app startup and whenever a new token is generated.

            _onNewToken = FirebaseMessaging.instance.onTokenRefresh.listen((token) => _saveToken(token));
            _onNewToken.onError((error) => _showError(error));

            _onNotificationTap = FirebaseMessaging.onMessageOpenedApp.listen((message) => _notificationTapped(message.data));
            _onNotificationTap.onError((error) => _showError(error));

            FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

            break;
        }
      } catch (e) {
        _showError('Error in Push Notification: $e');
      }
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await _notificationTapped(message.data);
  }

  void _showError(String error) {
    Msg.showErrorMsg(getContext(), error);
  }

  Future<void> _notificationTapped(Map<String?, Object?> data) async {
    await Commons.navigate(
      context: getContext(),
      builder: (context) => const Cygnus2(),
    );
  }

  Future<void> _saveToken(String? token) async {
    final userId = _storeAuth.currentUser?.uid;
    final email = _storeAuth.currentUser?.email;

    if (token == null) {
      _showError('Can not save Push Notification token because "Token" is null');
    } else {
      if (userId == null) {
        _showError('Can not save Push Notification token because "UserID" is null');
      } else {
        await save(
          FirebaseTables.tokens,
          userId,
          {
            'email': email,
            'token': token,
          },
        );
      }
    }
  }
}
