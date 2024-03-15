import 'package:flutter/material.dart';

typedef VoidCallbackFuture = Future<void> Function();

class ChatMessageBar extends StatefulWidget {
  final TextEditingController textBoxController;
  final VoidCallbackFuture onSend;

  const ChatMessageBar({
    super.key,
    required this.textBoxController,
    required this.onSend,
  });

  @override
  State<StatefulWidget> createState() => _ChatMessageBarState();
}

class _ChatMessageBarState extends State<ChatMessageBar> {
  final focusNode = FocusNode();

  bool sending = false;

  Future<void> send() async {
    setState(() => sending = true);

    await widget.onSend();

    setState(() => sending = false);

    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      focusNode: focusNode,
      maxLength: 300,
      controller: widget.textBoxController,
      onSubmitted: sending ? null : (v) => send(),
      decoration: InputDecoration(
        hintText: 'Scrivi un messaggio...',
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: sending ? null : () => send(),
        ),
      ),
    );
  }
}
