/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension DayOfWeekExtension on DayOfWeek {
  int get asInt => index;

  DayOfWeek get nextDay {
    switch (this) {
      case DayOfWeek.monday:
        return DayOfWeek.tuesday;
      case DayOfWeek.tuesday:
        return DayOfWeek.wednesday;
      case DayOfWeek.wednesday:
        return DayOfWeek.thursday;
      case DayOfWeek.thursday:
        return DayOfWeek.friday;
      case DayOfWeek.friday:
        return DayOfWeek.saturday;
      case DayOfWeek.saturday:
        return DayOfWeek.sunday;
      case DayOfWeek.sunday:
        return DayOfWeek.monday;
    }
  }

  String get shortLabel {
    switch (this) {
      case DayOfWeek.monday:
        return 'LUN';
      case DayOfWeek.tuesday:
        return 'MAR';
      case DayOfWeek.wednesday:
        return 'MER';
      case DayOfWeek.thursday:
        return 'GIO';
      case DayOfWeek.friday:
        return 'VEN';
      case DayOfWeek.saturday:
        return 'SAB';
      case DayOfWeek.sunday:
        return 'DOM';
    }
  }

  static DayOfWeek fromInt(int i) {
    switch (i) {
      case 0:
        return DayOfWeek.monday;
      case 1:
        return DayOfWeek.tuesday;
      case 2:
        return DayOfWeek.wednesday;
      case 3:
        return DayOfWeek.thursday;
      case 4:
        return DayOfWeek.friday;
      case 5:
        return DayOfWeek.saturday;
      case 6:
        return DayOfWeek.sunday;
      default:
        return DayOfWeek.monday;
    }
  }
}
