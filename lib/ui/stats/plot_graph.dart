/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cygnus2/data_structures/time_series.dart';

class PlotGraph extends StatelessWidget {
  final double? endingY;
  final TimeSeries? series;

  const PlotGraph({
    super.key,
    this.endingY,
    required this.series,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final labelColor = themeData.textTheme.labelMedium!.color!;

    final gLabelColor = Color(
      r: labelColor.red,
      g: labelColor.green,
      b: labelColor.blue,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TimeSeriesChart(
          [
            if (series != null) ...[
              for (final s in series!.sortedItems) ...[
                Series<TimeElement, DateTime>(
                  id: s.name,
                  data: s.items,
                  domainFn: (datum, index) => datum.date,
                  measureFn: (datum, index) => datum.value,
                ),
              ],
            ],
          ],
          animate: false,
          defaultRenderer: LineRendererConfig(
            includePoints: true,
          ),
          // X axis
          domainAxis: DateTimeAxisSpec(
            renderSpec: GridlineRendererSpec(
              labelStyle: TextStyleSpec(
                color: gLabelColor,
              ),
            ),
          ),
          // Y axis
          primaryMeasureAxis: NumericAxisSpec(
            renderSpec: GridlineRendererSpec(
              labelStyle: TextStyleSpec(
                color: gLabelColor,
              ),
            ),
            viewport: endingY == null
                ? null
                : NumericExtents(
                    0.0,
                    endingY!,
                  ),
            tickProviderSpec: const BasicNumericTickProviderSpec(
              dataIsInWholeNumbers: true,
              desiredTickCount: 10,
            ),
          ),
          behaviors: [
            SeriesLegend(
              position: BehaviorPosition.top,
              desiredMaxColumns: 4,
              desiredMaxRows: 1,
            ),
            ChartTitle(
              'Elementi',
              behaviorPosition: BehaviorPosition.start,
              titleStyleSpec: TextStyleSpec(
                fontSize: 12,
                color: gLabelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
