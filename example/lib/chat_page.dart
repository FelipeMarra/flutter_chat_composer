import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';
import 'package:flutter_chat_composer/widgets/bot_user_open_text.dart';

import 'my_chat_bot.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);

  final ChatBot chatBot = MyChatBot().chatBot;

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
        chatBot: chatBot,
      ),
    );
  }

  Widget _botMessageWidget(RichText message) {
    return Container(
      color: Colors.blue[200],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [message],
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

  Widget _userMessageWidget(RichText message) {
    return Container(
      color: Colors.purple[200],
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [message],
        ),
      ]),
    );
  }

  BotUserOpenText _userOpenTextWidget() {
    TextEditingController controller = TextEditingController();
    return BotUserOpenText(
      chatBot: chatBot,
      userMessageWidget: _userMessageWidget,
      textField: TextField(
        controller: controller,
      ),
      controller: controller,
      icon: const Icon(Icons.send),
      onPressed: () {
        print("Icon Button BotUserOpenText PRESSED");
      },
    );
  }
}
