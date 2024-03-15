/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:json_annotation/json_annotation.dart';
import 'package:cygnus2/data_structures/base_data.dart';

part 'tag_data.g.dart';

@JsonSerializable(explicitToJson: true)
class Tag {
  @JsonKey(toJson: BaseData.toNull, includeIfNull: false)
  String? idFirebase;

  final String tag, container;

  Tag({
    required this.idFirebase,
    required this.tag,
    required this.container,
  });

  String get fullDescription => '$container - $tag';

  Map<String, dynamic> toJson() => _$TagToJson(this);

  factory Tag.fromJson(String idFirebase, Map<String, dynamic> json) => BaseData.fromJson(
        idFirebase,
        json,
        (j) => _$TagFromJson(j),
      );
}

class InitialsTags {
  static final tags = [
    Tag(idFirebase: null, container: 'Servizi professionali', tag: 'Ripetizioni materie scolastiche'),
    Tag(idFirebase: null, container: 'Vendita e marketing', tag: 'Rappresentanze prodotti commerciali vari'),
    Tag(idFirebase: null, container: 'Vendita e marketing', tag: 'Volantinaggio'),
    Tag(idFirebase: null, container: 'Amministrazione', tag: 'Attività di assistenza presso uffici pubblici e privati'),
    Tag(idFirebase: null, container: 'Amministrazione', tag: 'Call center'),
    Tag(idFirebase: null, container: 'Assistenza sanitaria', tag: 'Assistenza domiciliare'),
    Tag(idFirebase: null, container: 'Assistenza sanitaria', tag: 'Assistenza mediante accompagnamento presso strutture pubbliche e/o private'),
    Tag(idFirebase: null, container: 'Assistenza sanitaria', tag: 'Assistenza persone anziane e bambini'),
    Tag(idFirebase: null, container: 'Servizi attinenti la ristorazione', tag: 'Cameriere presso ristoranti, pizzerie, ecc...'),
    Tag(idFirebase: null, container: 'Servizi attinenti la ristorazione', tag: 'Baristi'),
    Tag(idFirebase: null, container: 'Servizi attinenti la ristorazione', tag: 'Consegna a domicilio con mezzo proprio'),
    Tag(idFirebase: null, container: 'Servizi attinenti la ristorazione', tag: 'Consegna a domicilio senza mezzo proprio'),
    Tag(idFirebase: null, container: 'Servizi attinenti la ristorazione', tag: 'Servizi di cucina'),
    Tag(idFirebase: null, container: 'Servizi domestici', tag: 'Giardinaggio'),
    Tag(idFirebase: null, container: 'Servizi domestici', tag: 'Facchinaggio'),
    Tag(idFirebase: null, container: 'Servizi domestici', tag: 'Pulizia domestica'),
    Tag(idFirebase: null, container: 'Servizi domestici', tag: 'Assistenza e compagnia nei confronti di persone anziane'),
    Tag(idFirebase: null, container: 'Servizi domestici', tag: 'Assistenza animali domestici'),
    Tag(idFirebase: null, container: 'Servizi domestici', tag: 'Lavanderia e stireria'),
    Tag(idFirebase: null, container: 'Trasporti', tag: 'Accompagnamento con mezzo proprio'),
    Tag(idFirebase: null, container: 'Trasporti', tag: 'Accompagnamento senza mezzo proprio'),
    Tag(idFirebase: null, container: 'Trasporti', tag: 'Trasporti masserizie'),
  ];
}
