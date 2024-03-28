/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'dart:convert';

import 'package:cygnus2/data_structures/linkedin_profile.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:cygnus2/utility/web_window_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StoreLinkedin {
  static const yourClientId = '77qerz8x61auw7';
  static const yourCallbackUrl = 'http://localhost:9090/linkedin/';
  static const yourClientSecret = 'JqO1CFmSjv9K4yCP';

  // step 1
  Future<void> login() async {
    const url = 'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=$yourClientId&redirect_uri=$yourCallbackUrl&state=logincygnus2&scope=email openid profile';
    await Commons.navigateToUrl(url, WebWindowMode.self);
  }

  // step 2
  String getAuthorizationCodeFromStep2Response(Uri callbackUrl) {
    // http://localhost:9090/linkedin/
    // ?code=AQTvAspNxlYzdret
    // &state=logincygnus2
    final qp = callbackUrl.queryParameters;
    final code = qp['code'] ?? '';
    final state = qp['state'] ?? '';

    if (state != 'logincygnus2' || code.isEmpty) {
      throw Exception('Malformed login url');
    }

    return code;
  }

  // step 3
  Future<String> getAccessToken(String authorizationCodeFromStep2Response) async {
    final queryParams = {
      'grant_type': 'authorization_code',
      'code': authorizationCodeFromStep2Response,
      'client_id': yourClientId,
      'client_secret': yourClientSecret,
      'redirect_uri': yourCallbackUrl,
    };

    final query = Uri(queryParameters: queryParams).query;
    final url = 'https://www.linkedin.com/oauth/v2/accessToken?$query';

    final r = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (r.statusCode != 200) {
      throw Exception('"accessToken" Status code: ${r.statusCode}');
    }

    final Map<String, dynamic> json = jsonDecode(r.body);
    final String accessToken = json['access_token'] ?? '';

    if (accessToken.isEmpty) {
      throw Exception('No access token defined');
    }

    return accessToken;
  }

  // step 4
  Future<LinkedinProfile> userInfo(String accessToken) async {
    if (kDebugMode) {
      return const LinkedinProfile(
        surname: 'Uzumaki',
        name: 'Naruto',
        email: 'naruto.uzumaki@maionemiky.it',
      );
    } else {
      // create new user
      const url = 'https://api.linkedin.com/v2/userinfo';

      final r = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (r.statusCode != 200) {
        throw Exception('"userinfo" Status code: ${r.statusCode}');
      }

      final Map<String, dynamic> json = jsonDecode(r.body);

      return LinkedinProfile(
        surname: json['family_name'],
        name: json['given_name'],
        email: json['email'],
      );
    }
  }
}
