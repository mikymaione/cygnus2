/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/data_structures/base_data.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mad_filter.g.dart';

@JsonSerializable(explicitToJson: true)
class MadFilter {
  @JsonKey(toJson: BaseData.toNull, includeIfNull: false)
  final String? idFirebase;

  final bool cleared;
  final int? km;
  final int? ageFrom, ageTo;

  const MadFilter({
    required this.idFirebase,
    required this.cleared,
    required this.km,
    required this.ageFrom,
    required this.ageTo,
  });

  bool isInAgeRange(int age) {
    if (ageFrom != null && ageTo == null) {
      return age >= ageFrom!;
    } else if (ageFrom == null && ageTo != null) {
      return age <= ageTo!;
    } else if (ageFrom != null && ageTo != null) {
      return age >= ageFrom! && age <= ageTo!;
    } else {
      return true; // no filter set
    }
  }

  String? get ageRange {
    if (ageFrom != null && ageTo == null) {
      return '$ageFrom';
    } else if (ageFrom == null && ageTo != null) {
      return '$ageTo';
    } else if (ageFrom != null && ageTo != null) {
      return '$ageFrom - $ageTo';
    } else {
      return null;
    }
  }

  RangeValues? get ageRangeValues {
    if (ageFrom != null && ageTo == null) {
      return RangeValues(ageFrom!.toDouble(), Commons.maxAge);
    } else if (ageFrom == null && ageTo != null) {
      return RangeValues(Commons.minAge, ageTo!.toDouble());
    } else if (ageFrom != null && ageTo != null) {
      return RangeValues(ageFrom!.toDouble(), ageTo!.toDouble());
    } else {
      return null;
    }
  }

  bool get noFilterSet => km == null && ageFrom == null && ageTo == null;

  Map<String, dynamic> toJson() => _$MadFilterToJson(this);

  factory MadFilter.fromJson(String idFirebase, Map<String, dynamic> json) => BaseData.fromJson<MadFilter>(
        idFirebase,
        json,
        (j) => _$MadFilterFromJson(j),
      );

  static MadFilter? fromNullableJson(String idFirebase, Map<String, dynamic>? json) => json == null ? null : MadFilter.fromJson(idFirebase, json);
}
