/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:json_annotation/json_annotation.dart';
import 'package:cygnus2/data_structures/base_data.dart';
import 'package:cygnus2/utility/utility.dart';

part 'chats_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatsData {
  @JsonKey(toJson: BaseData.toNull, includeIfNull: false)
  String? idFirebase;

  final DateTime created;

  final Set<String> interlocutorsIds;
  final Map<String, bool> interlocutorsIdsMap;
  final Map<String, String> interlocutors;
  final String lastMessageText;
  final DateTime lastMessageData;

  ChatsData({
    required this.idFirebase,
    required this.created,
    required this.interlocutorsIdsMap,
    required this.interlocutorsIds,
    required this.interlocutors,
    required this.lastMessageText,
    required this.lastMessageData,
  });

  String info(String languageCode) => Utility.datetimeYMMMMDHm(languageCode, lastMessageData) + (lastMessageText.isEmpty ? '' : ' - $lastMessageText');

  String interlocutorId(String? myId) => interlocutors.entries
      .where(
        (e) => e.key != myId,
      )
      .first
      .key;

  String interlocutorName(String? myId) => interlocutors.entries
      .where(
        (e) => e.key != myId,
      )
      .first
      .value;

  Map<String, dynamic> toJson() => _$ChatsDataToJson(this);

  factory ChatsData.fromJson(String idFirebase, Map<String, dynamic> json) => BaseData.fromJson(
        idFirebase,
        json,
        (j) => _$ChatsDataFromJson(j),
      );
}
