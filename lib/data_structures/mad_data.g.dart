// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mad_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MadData _$MadDataFromJson(Map<String, dynamic> json) => MadData(
      idFirebase: json['idFirebase'] as String?,
      created: DateTime.parse(json['created'] as String),
      personId: json['personId'] as String,
      nickname: json['nickname'] as String,
      birthday:
          const TimestampConverter().fromJson(json['birthday'] as Timestamp),
      bio: json['bio'] as String?,
      university: json['university'] as String,
      department: json['department'] as String,
      location: json['location'],
    );

Map<String, dynamic> _$MadDataToJson(MadData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('idFirebase', BaseData.toNull(instance.idFirebase));
  val['created'] = instance.created.toIso8601String();
  val['personId'] = instance.personId;
  val['birthday'] = const TimestampConverter().toJson(instance.birthday);
  val['nickname'] = instance.nickname;
  val['bio'] = instance.bio;
  val['university'] = instance.university;
  val['department'] = instance.department;
  val['location'] = instance.location;
  return val;
}
