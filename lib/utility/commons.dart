/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/utility/web_window_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Commons {
  static const minAge = 18.0;
  static const maxAge = 130.0;

  static const defaultAge = RangeValues(minAge, maxAge);

  static printIfInDebug(Object? s) {
    if (kDebugMode) {
      print(s);
    }
  }

  static Future<X?> navigate<X>({required BuildContext context, required WidgetBuilder builder}) => Navigator.push<X>(
        context,
        MaterialPageRoute(
          builder: builder,
        ),
      );

  static Future<void> navigateToUrl(String url, WebWindowMode webWindowMode) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, webOnlyWindowName: webWindowMode.code);

    if (!ok) {
      throw Exception('Could not launch $url');
    }
  }
}
