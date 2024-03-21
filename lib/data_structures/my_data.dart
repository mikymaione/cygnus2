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
import 'package:cygnus2/data_structures/profile_data.dart';

class MyData {
  final MadData? madData;
  final MadFilter? filters;
  final ProfileData? profileData;
  final Iterable<Blocked>? blockedMe, blockedByMe;

  Set<String> get idsBlocked {
    final s = <String>{};

    if (blockedMe != null) {
      for (final h in blockedMe!) {
        s.addAll(h.items);
      }
    }

    if (blockedByMe != null) {
      for (final h in blockedByMe!) {
        s.addAll(h.items);
      }
    }

    return s;
  }

  const MyData({
    required this.madData,
    required this.filters,
    required this.profileData,
    required this.blockedMe,
    required this.blockedByMe,
  });
}
