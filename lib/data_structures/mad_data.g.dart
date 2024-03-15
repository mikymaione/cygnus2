// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mad_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MadData _$MadDataFromJson(Map<String, dynamic> json) => MadData(
      idFirebase: json['idFirebase'] as String?,
      updated: DateTime.parse(json['updated'] as String),
      personId: json['personId'] as String,
      nickname: json['nickname'] as String,
      birthday: DateTime.parse(json['birthday'] as String),
      bio: json['bio'] as String,
      university: json['university'] as String,
      department: json['department'] as String,
      img1: json['img1'] as String,
      img2: json['img2'] as String,
      img3: json['img3'] as String,
      img4: json['img4'] as String,
      img5: json['img5'] as String,
      img6: json['img6'] as String,
      whereCityName: (json['whereCityName'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      whereProvince: (json['whereProvince'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      whereProvinceCitiesName:
          (json['whereProvinceCitiesName'] as List<dynamic>)
              .map((e) => e as String)
              .toSet(),
    );

Map<String, dynamic> _$MadDataToJson(MadData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('idFirebase', BaseData.toNull(instance.idFirebase));
  val['updated'] = instance.updated.toIso8601String();
  val['personId'] = instance.personId;
  val['nickname'] = instance.nickname;
  val['birthday'] = instance.birthday.toIso8601String();
  val['bio'] = instance.bio;
  val['university'] = instance.university;
  val['department'] = instance.department;
  val['img1'] = instance.img1;
  val['img2'] = instance.img2;
  val['img3'] = instance.img3;
  val['img4'] = instance.img4;
  val['img5'] = instance.img5;
  val['img6'] = instance.img6;
  val['whereCityName'] = instance.whereCityName.toList();
  val['whereProvince'] = instance.whereProvince.toList();
  val['whereProvinceCitiesName'] = instance.whereProvinceCitiesName.toList();
  return val;
}
