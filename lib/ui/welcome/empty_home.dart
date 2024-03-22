/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/ui/base/no_element.dart';
import 'package:flutter/material.dart';

class EmptyHomePage<Z> extends StatefulWidget {
  final AsyncSnapshot<Z> snapshot;
  final String label;
  final IconData icon;

  const EmptyHomePage({
    super.key,
    required this.snapshot,
    required this.label,
    required this.icon,
  });

  @override
  State<EmptyHomePage<Z>> createState() => _EmptyHomePageState<Z>();
}

class _EmptyHomePageState<Z> extends State<EmptyHomePage<Z>> {
  Future<bool> _onWillPop() async => false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: widget.snapshot.hasError
              ? NoElement(
                  icon: Icons.error,
                  message: 'Errore: ${widget.snapshot.error}',
                  iconColor: Colors.pink,
                )
              : NoElement(
                  icon: widget.icon,
                  message: widget.label,
                  iconColor: Colors.pink,
                ),
        ),
      ),
    );
  }
}
