/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:age_calculator/age_calculator.dart';
import 'package:collection/collection.dart';
import 'package:cygnus2/data_structures/base_data.dart';
import 'package:cygnus2/ui/mad/city.dart';
import 'package:cygnus2/ui/mad/city_dao.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mad_data.g.dart';

@JsonSerializable(explicitToJson: true)
class MadData {
  @JsonKey(toJson: BaseData.toNull, includeIfNull: false)
  String? idFirebase;

  final DateTime updated;

  final String personId;

  final String nickname;
  final DateTime birthday;
  final String? bio;

  final String university;
  final String department;

  // bse64
  final String img1;
  final String? img2, img3, img4, img5, img6;

  final Set<String> whereCityName; // ['Alpignano', 'Barbania']
  final Set<String> whereProvince; // ['Napoli', 'Torino']
  final Set<String> whereProvinceCitiesName; // ['Napoli', 'Portici', 'Marano']

  int get age => AgeCalculator.age(birthday).years;

  String get ageS => '$age years';

  Iterable<String> get whereCitiesNameByProvince => whereCitiesByProvince.map(
        (c) => c.name,
      );

  Iterable<City> get whereCitiesByProvince => whereProvince
      .map(
        (p) => CityDao.citiesByProvince(p),
      )
      .expand((c) => c)
      .whereNotNull();

  Iterable<String> get whereCitiesOnlyName => whereCities.map(
        (c) => c.displayName,
      );

  Iterable<City> get whereCities => whereCityName
      .map(
        (c) => CityDao.getCityByName(c),
      )
      .whereNotNull();

  Iterable<City> get whereProvinceCities => whereProvinceCitiesName
      .map(
        (c) => CityDao.getCityByName(c),
      )
      .whereNotNull();

  MadData({
    required this.idFirebase,
    required this.updated,
    required this.personId,
    required this.nickname,
    required this.birthday,
    this.bio,
    required this.university,
    required this.department,
    required this.img1,
    this.img2,
    this.img3,
    this.img4,
    this.img5,
    this.img6,
    required this.whereCityName,
    required this.whereProvince,
    required this.whereProvinceCitiesName,
  });

  Map<String, dynamic> toJson() => _$MadDataToJson(this);

  factory MadData.fromJson(String idFirebase, Map<String, dynamic> json) => BaseData.fromJson<MadData>(
        idFirebase,
        json,
        (j) => _$MadDataFromJson(j),
      );
}
