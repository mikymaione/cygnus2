// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mad_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MadFilter _$MadFilterFromJson(Map<String, dynamic> json) => MadFilter(
      idFirebase: json['idFirebase'] as String?,
      cleared: json['cleared'] as bool,
      km: json['km'] as int?,
    );

Map<String, dynamic> _$MadFilterToJson(MadFilter instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('idFirebase', BaseData.toNull(instance.idFirebase));
  val['cleared'] = instance.cleared;
  val['km'] = instance.km;
  return val;
}
