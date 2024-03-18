/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/utility/generic_range.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utility {
  //
  static DateTime todayOnlyDate() => toOnlyDate(DateTime.now());

  static DateTime toOnlyDate(DateTime n) => DateTime(n.year, n.month, n.day);

  static String timeRangeToString(TimeOfDay a, TimeOfDay b) => '${timeOfDayToString(a)}-${timeOfDayToString(b)}';

  static String? timeOfDayToString(TimeOfDay? t) => t == null ? null : '${hourToString(t)}:${minuteToString(t)}';

  static String hourToString(TimeOfDay t) => t.hour < 10 ? '0${t.hour}' : '${t.hour}';

  static String minuteToString(TimeOfDay t) => t.minute < 10 ? '0${t.minute}' : '${t.minute}';

  static TimeOfDay stringToTimeOfDay(String s) {
    final a = s.split(':');

    return TimeOfDay(
      hour: int.tryParse(a[0]) ?? 0,
      minute: int.tryParse(a[1]) ?? 0,
    );
  }

  static GenericRange<TimeOfDay> stringToRange(String s) {
    final a = s.split('-');

    return GenericRange<TimeOfDay>(
      stringToTimeOfDay(a[0]),
      stringToTimeOfDay(a[1]),
    );
  }

  static String left(String? s, int len) => s == null
      ? ''
      : s.length < len
          ? s
          : '${s.substring(0, len)}…';

  static String datetimeYMMMMDHm(String languageCode, DateTime d) => DateFormat.yMMMMd(languageCode).add_Hm().format(d);

  static String datetimeYMMMMDHms(String languageCode, DateTime d) => DateFormat.yMMMMd(languageCode).add_Hms().format(d);

  static String datetimeYMMMMD(String languageCode, DateTime d) => DateFormat.yMMMMd(languageCode).format(d);

  static String datetimeYMD(String languageCode, DateTime d) => DateFormat.yMd(languageCode).format(d);

  static bool isEqualOrBefore(DateTime a, DateTime b) => a == b || a.isBefore(b);

  static bool isEqualOrAfter(DateTime a, DateTime b) => a == b || a.isAfter(b);

  static bool timeOfDayIsEqual(TimeOfDay a, TimeOfDay b) => a.hour == b.hour && a.minute == b.minute;

  static bool timeOfDayIsBefore(TimeOfDay a, TimeOfDay b) => a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);

  static bool timeOfDayIsEqualOrBefore(TimeOfDay a, TimeOfDay b) => timeOfDayIsEqual(a, b) || timeOfDayIsBefore(a, b);

  static bool workHourContained(GenericRange<TimeOfDay> my, GenericRange<TimeOfDay> job) => timeOfDayIsEqualOrBefore(my.from, job.from) && timeOfDayIsEqualOrBefore(job.to, my.to);

  static bool workHourContainedFromString(String my, String job) => workHourContained(stringToRange(my), stringToRange(job));
}
