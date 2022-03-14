import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

import 'my_chat_bot.dart';

void main() {
  runApp(const ChatBotInteractionApp());
}

class ChatBotInteractionApp extends StatelessWidget {
  const ChatBotInteractionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatBot chatBot = MyChatBot().chatBot();
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
