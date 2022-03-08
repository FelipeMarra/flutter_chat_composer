import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';
import 'package:flutter_chat_composer/widgets/bot_message_widget.dart';
import 'package:flutter_chat_composer/widgets/bot_user_open_text.dart';
import 'package:flutter_chat_composer/widgets/user_message_widget.dart';

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
        botMessageWidget: (message) => BotMessageWidget(message: message),
        botTransitionWidget: _botTransitionWidget,
        userMessageWidget: (message) => UserMessageWidget(message: message),
        userOpenTextWidget: BotUserOpenText(
          chatBot: chatBot,
          userMessageWidget: (message) => UserMessageWidget(message: message),
          controller: TextEditingController(),
          icon: const Icon(Icons.send),
        ),
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
