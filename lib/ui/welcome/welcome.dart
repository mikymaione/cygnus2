/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:cygnus2/ui/base/screen.dart';
import 'package:cygnus2/ui/welcome/welcome_content_card.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  //
  var activePage = 0;

  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textColor = themeData.textTheme.labelMedium!.color!;
    final textColorDark = textColor.withOpacity(0.5);

    return Screen(
      title: 'Cygnus2',
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // cards
            Expanded(
              child: PageView(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => activePage = page),
                children: const [
                  WelcomeContentCard(
                    isLastPage: false,
                    imgUrl: 'assets/images/dev.png',
                    text: 'Benvenuto in Cygnus2, il social network per le collaborazioni. Cygnus2 nasce dalla volontà di mettere in contatto persone che vogliono collaborare tra loro.',
                  ),
                  WelcomeContentCard(
                    isLastPage: false,
                    imgUrl: 'assets/images/clean.png',
                    text: 'Condividi con gli altri le tue capacità e le tue disponibilità.',
                  ),
                  WelcomeContentCard(
                    isLastPage: false,
                    imgUrl: 'assets/images/chair.png',
                    text: 'Oppure cerca chi possa aiutarti con le tue necessità.',
                  ),
                  WelcomeContentCard(
                    isLastPage: true,
                    imgUrl: 'assets/images/all.png',
                    text: 'Per entrare a far parte di Cygnus2 leggi e accetta i "termini e condizioni" e la "politica sulla riservatezza".',
                  ),
                ],
              ),
            ),

            // position indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // back button
                IconButton(
                  icon: const Icon(Icons.arrow_circle_left_outlined),
                  onPressed: activePage == 0 ? null : () => controller.jumpToPage(activePage - 1),
                ),

                // status dots
                for (var x = 0; x < 4; x++) ...[
                  Container(
                    margin: const EdgeInsets.all(3),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: x == activePage ? textColor : textColorDark,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],

                // next button
                IconButton(
                  icon: const Icon(Icons.arrow_circle_right_outlined),
                  onPressed: activePage == 3 ? null : () => controller.jumpToPage(activePage + 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
