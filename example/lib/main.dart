import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

import 'my_chat_bot.dart';

void main() {
  runApp(const ChatBotInteractionApp());
}

class ChatBotInteractionApp extends StatefulWidget {
  const ChatBotInteractionApp({Key? key}) : super(key: key);

  @override
  State<ChatBotInteractionApp> createState() => _ChatBotInteractionAppState();
}

class _ChatBotInteractionAppState extends State<ChatBotInteractionApp> {
  ChatBot chatBot = MyChatBot().chatBot();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("My ChatBot"),
          centerTitle: true,
        ),
        body: ChatBotWidget(
          chatBot: chatBot,
          sameUserSpacing: 3,
        ),
      ),
    );
  }
}
