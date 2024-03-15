// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatData _$ChatDataFromJson(Map<String, dynamic> json) => ChatData(
      idFirebase: json['idFirebase'] as String?,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      data: DateTime.parse(json['data'] as String),
    );

Map<String, dynamic> _$ChatDataToJson(ChatData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('idFirebase', BaseData.toNull(instance.idFirebase));
  val['chatId'] = instance.chatId;
  val['senderId'] = instance.senderId;
  val['text'] = instance.text;
  val['data'] = instance.data.toIso8601String();
  return val;
}
