library flutter_chat_composer;

import 'package:flutter/material.dart';

import 'package:flutter_chat_composer/models/chat_bot_models.dart';
import 'package:flutter_chat_composer/widgets/message_widget/message_widge.dart';

export 'models/chat_bot_models.dart' show ChatBot, BotState, BotOption;

class ChatBotWidget extends StatefulWidget {
  final ChatBot chatBot;

  const ChatBotWidget({
    Key? key,
    required this.chatBot,
  }) : super(key: key);

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget> {
  List<MessageWidget> chat = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.chatBot.currentState?.messages[0].texts[0] ?? const Text(""),
      ],
    );
  }
}
