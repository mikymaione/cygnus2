/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:collection/collection.dart';
import 'package:cygnus2/utility/utility.dart';

class TimeElement {
  final DateTime date;
  final int value;

  const TimeElement({
    required this.date,
    required this.value,
  });
}

class TimeSerie {
  final String name;
  final List<TimeElement> items;

  const TimeSerie({
    required this.name,
    required this.items,
  });

  factory TimeSerie.fromDate(String name, Iterable<DateTime>? date) {
    // date: 01/01/2023, 01/01/2023, 01/01/2023, 02/01/2023, 02/01/2023, 03/01/2023, 03/01/2023, 03/01/2023, 03/01/2023
    // onlyDate: 01/01/2023, 02/01/2023, 02/01/2023, 03/01/2023
    final onlyDate = [
      if (date != null) ...[
        for (final d in date) ...[
          Utility.toOnlyDate(d),
        ],
      ],
    ].sorted(
      (a, b) => a.compareTo(b),
    );

    final m = <DateTime, int>{};

    var i = 0;
    for (var x = 0; x < onlyDate.length; x++) {
      final d = onlyDate[x];

      i += 1;

      if (m.containsKey(d)) {
        m[d] = i;
      } else {
        m.putIfAbsent(d, () => i);
      }
    }

    return TimeSerie(
      name: name,
      items: [
        for (final v in m.entries) ...[
          TimeElement(date: v.key, value: v.value),
        ]
      ],
    );
  }
}

class TimeSeries {
  final List<TimeSerie> items;

  List<TimeSerie> get sortedItems => items.sorted(
        (a, b) => a.name.compareTo(b.name) * -1,
      );

  const TimeSeries({
    required this.items,
  });
}
