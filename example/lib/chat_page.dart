import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/models/chat_bot_models.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

import 'my_chat_bot.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatBot"),
      ),
      body: ChatBotWidget(
        botMessageWidget: _botMessageWidget,
        botTransitionWidget: _botTransitionWidget,
        userMessageWidget: _userMessageWidget,
        userOpenTextWidget: _userOpenTextWidget,
        sameUserSpacing: 1,
        difUsersSpacing: 10,
        chatBot: MyChatBot().chatBot,
      ),
    );
  }

  Widget _botMessageWidget(Message message) {
    return Container(
      color: Colors.blue[200],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: message.texts,
      ),
    );
  }

  Widget _botTransitionWidget(Message message) {
    //Put all message texts together
    return Container(
      color: Colors.blue[400],
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: message.texts,
        ),
      ]),
    );
  }

  Widget _userMessageWidget(Message message) {
    return Container(
      color: Colors.purple[200],
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: message.texts,
        ),
      ]),
    );
  }

  TextField _userOpenTextWidget(TextEditingController controller) {
    return TextField(
      controller: controller,
    );
  }
}
