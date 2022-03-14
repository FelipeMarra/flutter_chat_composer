import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

//import 'my_chat_bot.dart';
import 'my_chat_bot_2.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatBot chatBot = MyChatBot2().chatBot();

    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatBot"),
      ),
      body: ChatBotWidget(
        chatBot: chatBot,
        sameUserSpacing: 5,
        difUsersSpacing: 10,
      ),
    );
  }
}
