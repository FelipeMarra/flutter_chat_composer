import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

import 'my_chat_bot.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatBot chatBot = MyChatBot().chatBot;

    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatBot"),
      ),
      body: ChatBotWidget(
        chatBot: chatBot,
        botTransitionWidget: _botTransitionWidget,
        sameUserSpacing: 1,
        difUsersSpacing: 10,
      ),
    );
  }

  Widget _botTransitionWidget(RichText message) {
    //Put all message texts together
    return Container(
      color: Colors.blue[400],
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [message],
        ),
      ]),
    );
  }
}
