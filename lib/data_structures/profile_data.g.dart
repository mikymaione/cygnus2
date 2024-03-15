// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
      idFirebase: json['idFirebase'] as String,
      created: DateTime.parse(json['created'] as String),
      surname: json['surname'] as String,
      name: json['name'] as String,
      admin: json['admin'] as bool?,
    );

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('idFirebase', BaseData.toNull(instance.idFirebase));
  val['created'] = instance.created.toIso8601String();
  val['surname'] = instance.surname;
  val['name'] = instance.name;
  val['admin'] = instance.admin;
  return val;
}
