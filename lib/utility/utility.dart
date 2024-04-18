/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'dart:convert';
import 'dart:typed_data';

import 'package:cygnus2/utility/commons.dart';
import 'package:cygnus2/utility/generic_range.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utility {
  //
  static final Set<String> universities = {
    'ateneo.univr.it',
    'gssi.it',
    'hunimed.eu',
    'imtlucca.it',
    'iuav.it',
    'iulm.it',
    'iusspavia.it',
    'liuc.it',
    'luiss.it',
    'lum.it',
    'lumsa.it',
    'poliba.it ',
    'polimi.it',
    'polito.it',
    'santannapisa.it',
    'sissa.it',
    'sns.it',
    'strutture.univaq.it',
    'uniba.it',
    'unibas.it',
    'unibg.it',
    'unibo.it',
    'unibocconi.it',
    'unibs.it',
    'unibz.it',
    'unica.it ',
    'unical.it ',
    'unicam.it',
    'unicampania.it',
    'unicampus.it',
    'unicas.it',
    'unicatt.it',
    'unich.it',
    'unict.it',
    'unicz.it',
    'unife.it',
    'unifg.it',
    'unifi.it',
    'unige.it',
    'unikore.it',
    'unilink.it',
    'unimc.it',
    'unime.it',
    'unimi.it',
    'unimib.it',
    'unimol.it',
    'unimore.it',
    'unina.it',
    'uninsubria.it',
    'unint.eu',
    'unior.it',
    'unipa.it',
    'uniparthenope.it',
    'unipd.it',
    'unipg.it',
    'unipi.it',
    'unipr.it',
    'unipv.it',
    'unirc.it',
    'uniroma1.it',
    'uniroma2.it',
    'uniroma3.it',
    'uniroma4.it',
    'unisa.it',
    'unisalento.it',
    'unisannio.it',
    'unisg.it',
    'unisi.it',
    'unisob.na.it',
    'unisr.it',
    'uniss.it',
    'unistrapg.it',
    'unistrasi.it',
    'unite.it',
    'unitn.it',
    'unito.it',
    'units.it',
    'unitus.it',
    'uniud.it',
    'uniupo.it',
    'uniurb.it',
    'univda.it',
    'unive.it',
    'univpm.it',
  };

  static String? validateEmailNormal(String? email) {
    if (email != null) {
      if (EmailValidator.validate(email)) {
        return null;
      }
    }

    return "Si prega di usare un indirizzo email valido!";
  }

  static String? validateEmail(String? email) => getUniversityByEmail(email) == null ? "Si prega di usare un indirizzo email universitario!" : null;

  static String? getUniversityByEmail(String? email) {
    if (email != null) {
      // gennaro.esposito@studenti.unina.it
      if (EmailValidator.validate(email)) {
        // 0- gennaro.esposito
        // 1- studenti.unina.it
        final emailParts = email.split("@");

        if (emailParts.length == 2) {
          // studenti.unina.it
          final domain = emailParts[1].toLowerCase();

          for (final d in universities) {
            if (domain.contains(d)) {
              return d;
            }
          }
        }
      }
    }

    return null;
  }

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

  static Uint8List? decodeBase64(String? base64) {
    if (base64 != null) {
      try {
        return base64Decode(base64);
      } catch (e) {
        Commons.printIfInDebug(e);
      }
    }

    return null;
  }
}
