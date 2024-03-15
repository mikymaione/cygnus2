// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatData _$StatDataFromJson(Map<String, dynamic> json) => StatData(
      idFirebase: json['idFirebase'] as String?,
      name: json['name'] as String,
      data: DateTime.parse(json['data'] as String),
    );

Map<String, dynamic> _$StatDataToJson(StatData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('idFirebase', BaseData.toNull(instance.idFirebase));
  val['name'] = instance.name;
  val['data'] = instance.data.toIso8601String();
  return val;
}
