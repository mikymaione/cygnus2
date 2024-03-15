// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blocked _$BlockedFromJson(Map<String, dynamic> json) => Blocked(
      idFirebase: json['idFirebase'] as String?,
      id1: json['id1'] as String,
      id2: json['id2'] as String,
    );

Map<String, dynamic> _$BlockedToJson(Blocked instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('idFirebase', BaseData.toNull(instance.idFirebase));
  val['id1'] = instance.id1;
  val['id2'] = instance.id2;
  return val;
}
