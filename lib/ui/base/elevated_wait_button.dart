/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/utility/commons.dart';
import 'package:flutter/material.dart';

typedef VoidCallbackFuture = Future<void> Function();

class ElevatedWaitButton extends StatefulWidget {
  final Widget child;
  final VoidCallbackFuture onPressed;
  final ButtonStyle? style;

  const ElevatedWaitButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  State<ElevatedWaitButton> createState() => _ElevatedWaitButtonState();
}

class _ElevatedWaitButtonState extends State<ElevatedWaitButton> {
  var isLoading = false;
  var isDisposed = false;

  void showInLoading() {
    setState(() => isLoading = true);
  }

  void hideInLoading() {
    if (!isDisposed) {
      try {
        setState(() => isLoading = false);
      } catch (e) {
        // probably widget.onPressed!.call(); have disposed the screen
        Commons.printIfInDebug(e);
      }
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      onPressed: () async {
        showInLoading();

        try {
          await widget.onPressed.call();
          hideInLoading();
        } catch (eOnPressed) {
          hideInLoading();
          rethrow;
        }
      },
      child: isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // circular progress indicator
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 2.5,
                    ),
                  ),
                ),

                // space
                const SizedBox(width: 8),

                // content
                widget.child,
              ],
            )
          : widget.child,
    );
  }
}
