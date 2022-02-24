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
        title: const Text("APP"),
      ),
      body: ChatBotWidget(
        botMessageWidget: _botMessageWidget,
        botOptionWidget: _botTransitionWidget,
        userMessageWidget: _userMessageWidget,
        chatBot: MyChatBot().chatBot,
      ),
    );
  }

  Widget _botMessageWidget(List<Message> messages) {
    List<Widget> messagesWidget = [];

    //Put all messages texts together
    for (Message message in messages) {
      messagesWidget.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: message.texts,
        ),
      );
    }

    return Container(
      color: Colors.blue[200],
      child: Column(
        children: messagesWidget,
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
}
