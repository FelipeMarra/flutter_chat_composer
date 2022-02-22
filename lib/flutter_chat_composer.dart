library flutter_chat_composer;

import 'package:flutter/material.dart';

import 'package:flutter_chat_composer/chat_machine.dart';

export './chat_machine.dart' show ChatBot, BotState, BotOption;

class ChatBotWidget extends StatelessWidget {
  final ChatBot chatBot;

  const ChatBotWidget({
    Key? key,
    required this.chatBot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        chatBot.currentState?.messages[0].texts[0] ?? const Text(""),
      ],
    );
  }
}