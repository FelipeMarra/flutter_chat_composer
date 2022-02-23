library flutter_chat_composer;

import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/models/chat_bot_models.dart';

export 'models/chat_bot_models.dart' show ChatBot, BotState, BotOption;

class ChatBotWidget extends StatefulWidget {
  final ChatBot chatBot;
  final Widget Function(Message) botMessageWidget;
  final Widget Function(Text) botOptionWidget;
  final Widget Function(Text) userMessageWidget;

  const ChatBotWidget({
    Key? key,
    required this.chatBot,
    required this.botMessageWidget,
    required this.botOptionWidget,
    required this.userMessageWidget,
  }) : super(key: key);

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget> {
  List<Widget> chat = [];

  @override
  void initState() {
    chat.add(widget.botMessageWidget(widget.chatBot.currentState!.messages[0]));
    chat.add(widget.botOptionWidget(
        widget.chatBot.currentState!.options[0].optionText));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.botMessageWidget(widget.chatBot.currentState!.messages[0]);
  }
}
