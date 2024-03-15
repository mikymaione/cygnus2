/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:collection/collection.dart';
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/store/store_mad.dart';
import 'package:cygnus2/ui/base/no_element.dart';
import 'package:cygnus2/ui/mad/mad_card.dart';
import 'package:cygnus2/ui/mad/mad_filter.dart';
import 'package:cygnus2/ui/mad/mad_filters.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:cygnus2/utility/generic_controller.dart';
import 'package:flutter/material.dart';

class MadListFiltered extends StatefulWidget {
  final MyData? myProfile;

  final GenericController<MadFilter> filters;

  const MadListFiltered({
    super.key,
    required this.myProfile,
    required this.filters,
  });

  @override
  State<StatefulWidget> createState() => _MadListFilteredState();
}

class _MadListFilteredState extends State<MadListFiltered> {
  final scrollController = ScrollController();
  final storeMad = StoreMad();

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  Future<void> showFilters() async {
    // show filter screen
    final f = await Commons.navigate<MadFilter>(
      context: context,
      builder: (context) => MadFilters(
        filters: widget.filters.value,
      ),
    );

    if (f != null) {
      setState(() => widget.filters.value = f.cleared ? null : f);
    }
  }

  List<MadData> sortMads(Iterable<MadData>? mads) => mads == null
      ? List<MadData>.empty(growable: false)
      : mads.sorted(
          (a, b) => a.updated.compareTo(b.updated),
        );

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  icon: Icon(widget.filters.value == null ? Icons.filter_list_off : Icons.filter_list),
                  label: Text(widget.filters.value == null ? 'Filtra i risultati' : 'Modifica i filtri'),
                  onPressed: () => showFilters(),
                ),

                // filter list
                if (widget.filters.value != null) ...[
                  if (widget.filters.value!.city != null) ...[
                    Chip(label: Text(widget.filters.value!.city!)),
                  ],
                ],
              ],
            ),
          ),
        ),

        // list of mads
        StreamBuilder<Iterable<MadData>>(
          stream: storeMad.searchMads(widget.myProfile?.profileData.idFirebase, widget.filters.value),
          builder: (context, snapshot) {
            final items = sortMads(snapshot.data);
            final count = snapshot.data?.length ?? 0;

            return count == 0
                ? NoElement(
                    icon: Icons.explore,
                    iconColor: Colors.blue,
                    message: 'Nessun profilo trovato per i filtri applicati',
                    onClickText: 'Modifica i filtri per la ricerca',
                    onClick: () => showFilters(),
                  )
                : Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: scrollController,
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final mad = items[index];

                          return MadCard(
                            myProfile: widget.myProfile!,
                            mad: mad,
                            onTap: null,
                          );
                        },
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }
}
