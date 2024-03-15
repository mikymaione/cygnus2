// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsData _$ChatsDataFromJson(Map<String, dynamic> json) => ChatsData(
      idFirebase: json['idFirebase'] as String?,
      created: DateTime.parse(json['created'] as String),
      interlocutorsIdsMap:
          Map<String, bool>.from(json['interlocutorsIdsMap'] as Map),
      interlocutorsIds: (json['interlocutorsIds'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      interlocutors: Map<String, String>.from(json['interlocutors'] as Map),
      lastMessageText: json['lastMessageText'] as String,
      lastMessageData: DateTime.parse(json['lastMessageData'] as String),
    );

Map<String, dynamic> _$ChatsDataToJson(ChatsData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('idFirebase', BaseData.toNull(instance.idFirebase));
  val['created'] = instance.created.toIso8601String();
  val['interlocutorsIds'] = instance.interlocutorsIds.toList();
  val['interlocutorsIdsMap'] = instance.interlocutorsIdsMap;
  val['interlocutors'] = instance.interlocutors;
  val['lastMessageText'] = instance.lastMessageText;
  val['lastMessageData'] = instance.lastMessageData.toIso8601String();
  return val;
}
