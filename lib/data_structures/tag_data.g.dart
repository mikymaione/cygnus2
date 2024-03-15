// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      idFirebase: json['idFirebase'] as String?,
      tag: json['tag'] as String,
      container: json['container'] as String,
    );

Map<String, dynamic> _$TagToJson(Tag instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('idFirebase', BaseData.toNull(instance.idFirebase));
  val['tag'] = instance.tag;
  val['container'] = instance.container;
  return val;
}
