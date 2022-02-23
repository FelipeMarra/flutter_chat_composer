import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/models/chat_bot_models.dart';

class MessageWidget extends StatefulWidget {
  final List<Message> messages;

  const MessageWidget({
    Key? key,
    required this.messages,
  }) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
