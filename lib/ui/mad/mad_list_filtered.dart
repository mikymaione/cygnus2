/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:collection/collection.dart';
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:cygnus2/data_structures/mad_filter.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_filter.dart';
import 'package:cygnus2/store/store_mad.dart';
import 'package:cygnus2/ui/base/no_element.dart';
import 'package:cygnus2/ui/mad/mad_card.dart';
import 'package:cygnus2/ui/mad/mad_filters.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:flutter/material.dart';

class MadListFiltered extends StatefulWidget {
  final MyData? myProfile;

  const MadListFiltered({
    super.key,
    required this.myProfile,
  });

  @override
  State<StatefulWidget> createState() => _MadListFilteredState();
}

class _MadListFilteredState extends State<MadListFiltered> {
  final storeMad = StoreMad();
  final storeFilter = StoreFilter();

  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> showFilters(MadFilter? filters) async => await Commons.navigate<void>(
        context: context,
        builder: (context) => MadFilters(
          myProfile: widget.myProfile!,
          filters: filters,
        ),
      );

  List<MadData> sortMads(Iterable<MadData>? mads) => mads == null
      ? const <MadData>[]
      : mads.sorted(
          (a, b) => a.created.compareTo(b.created),
        );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MadFilter?>(
      stream: storeFilter.getFilter(widget.myProfile?.profileData?.idFirebase),
      builder: (context, snapFilter) => Column(
        children: [
          // filters
          Card(
            elevation: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Show filters button
                  OutlinedButton.icon(
                    icon: Icon(snapFilter.data == null ? Icons.filter_list_off : Icons.filter_list),
                    label: Text(snapFilter.data == null ? 'Filtra i risultati' : 'Modifica i filtri'),
                    onPressed: () => showFilters(snapFilter.data),
                  ),

                  // filter list
                  if (snapFilter.data?.km != null) ...[
                    Chip(
                      label: Text('${snapFilter.data!.km!}km'),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // list of mads
          StreamBuilder<Iterable<MadData>>(
            stream: storeMad.searchMads(
              widget.myProfile?.profileData?.idFirebase,
              snapFilter.data,
              widget.myProfile?.madData?.geoFirePoint,
              4,
            ),
            builder: (context, snapshot) {
              final items = sortMads(snapshot.data);

              return items.isEmpty
                  ? NoElement(
                      icon: Icons.explore,
                      iconColor: Colors.blue,
                      message: 'Nessun profilo trovato per i filtri applicati',
                      onClickText: 'Modifica i filtri per la ricerca',
                      onClick: () => showFilters(snapFilter.data),
                    )
                  : Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: scrollController,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: items.length,
                          itemBuilder: (context, index) => MadCard(
                            myProfile: widget.myProfile!,
                            mad: items[index],
                          ),
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
