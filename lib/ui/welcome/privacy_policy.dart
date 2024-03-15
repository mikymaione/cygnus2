/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cygnus2/ui/base/screen.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<StatefulWidget> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Politica sulla riservatezza',
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assets/documents/privacy_policy.md'),
        builder: (context, snapshot) => snapshot.hasData
            ? Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Markdown(
                        selectable: true,
                        data: snapshot.requireData,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Indietro'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
