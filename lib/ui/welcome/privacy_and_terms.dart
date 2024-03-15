/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:flutter/material.dart';
import 'package:cygnus2/ui/otp/login_screen.dart';
import 'package:cygnus2/ui/welcome/privacy_policy.dart';
import 'package:cygnus2/ui/welcome/terms_and_conditions.dart';
import 'package:cygnus2/utility/commons.dart';

class PrivacyAndTerms extends StatefulWidget {
  const PrivacyAndTerms({super.key});

  @override
  State<StatefulWidget> createState() => _PrivacyAndTermsState();
}

class _PrivacyAndTermsState extends State<PrivacyAndTerms> {
  var privacyOk = false;
  var privacyRead = false;
  var termsOk = false;
  var termsRead = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Accept Terms & Conditions
        if (termsRead) ...[
          Row(
            children: [
              Checkbox(
                value: termsOk,
                onChanged: (value) => setState(() => termsOk = true == value),
              ),
              const Expanded(
                child: Text('Accetto i termini e condizioni'),
              ),
            ],
          ),
        ] else ...[
          ElevatedButton(
            onPressed: () async {
              await Commons.navigate(
                context: context,
                builder: (context) => const TermsAndConditions(),
              );

              setState(() => termsRead = true);
            },
            child: const Text('Leggi i termini e condizioni'),
          ),
        ],
        const SizedBox(height: 8),

        // Accept Privacy Policy
        if (privacyRead) ...[
          Row(
            children: [
              Checkbox(
                value: privacyOk,
                onChanged: (value) => setState(() => privacyOk = true == value),
              ),
              const Expanded(
                child: Text('Accetto la politica sulla riservatezza'),
              ),
            ],
          ),
        ] else ...[
          ElevatedButton(
            onPressed: () async {
              await Commons.navigate(
                context: context,
                builder: (context) => const PrivacyPolicy(),
              );

              setState(() => privacyRead = true);
            },
            child: const Text('Leggi la politica sulla riservatezza'),
          ),
        ],

        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: termsOk && privacyOk
              ? () => Commons.navigate(
                    context: context,
                    builder: (context) => const LoginScreen(),
                  )
              : null,
          child: const Text('Entra'),
        ),
      ],
    );
  }
}
