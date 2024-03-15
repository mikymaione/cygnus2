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

part 'chat_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatData {
  @JsonKey(toJson: BaseData.toNull, includeIfNull: false)
  String? idFirebase;

  final String chatId, senderId, text;
  final DateTime data;

  String dateFull(String languageCode) => Utility.datetimeYMMMMDHm(languageCode, data);

  String dateFullSec(String languageCode) => Utility.datetimeYMMMMDHms(languageCode, data);

  bool isMine(String personId) => senderId == personId;

  ChatData({
    required this.idFirebase,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.data,
  });

  Map<String, dynamic> toJson() => _$ChatDataToJson(this);

  factory ChatData.fromJson(String idFirebase, Map<String, dynamic> json) => BaseData.fromJson(
        idFirebase,
        json,
        (j) => _$ChatDataFromJson(j),
      );
}
