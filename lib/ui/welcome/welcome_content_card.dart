/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:cygnus2/ui/welcome/privacy_and_terms.dart';

class WelcomeContentCard extends StatelessWidget {
  final bool isLastPage;
  final String text, imgUrl;

  const WelcomeContentCard({
    super.key,
    required this.isLastPage,
    required this.text,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // image
            Flexible(
              child: Image.asset(
                imgUrl,
                fit: BoxFit.contain,
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  // text
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      text,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  // show privacy and terms
                  if (isLastPage) ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: PrivacyAndTerms(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
