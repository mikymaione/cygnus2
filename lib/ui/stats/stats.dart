/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:cygnus2/data_structures/time_series.dart';
import 'package:cygnus2/store/store_stats.dart';
import 'package:cygnus2/ui/stats/plot_graph.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<StatefulWidget> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final storeStats = StoreStats();

  @override
  void initState() {
    super.initState();
    storeStats.updateStats();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TimeSeries>(
      stream: storeStats.stats(),
      builder: (context, snapshot) => PlotGraph(
        series: snapshot.data,
      ),
    );
  }
}
