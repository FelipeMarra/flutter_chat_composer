import 'package:flutter/material.dart';

import 'package:flutter_chat_composer/flutter_chat_composer.dart';

import 'my_chat_bot.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ChatBotInteractionApp(),
    ),
  );
}

class ChatBotInteractionApp extends StatefulWidget {
  const ChatBotInteractionApp({Key? key}) : super(key: key);

  @override
  State<ChatBotInteractionApp> createState() => _ChatBotInteractionAppState();
}

class _ChatBotInteractionAppState extends State<ChatBotInteractionApp> {
  ChatBot chatBot = MyChatBot().chatBot();

  @override
  void initState() {
    _goToHistorytest();
    super.initState();
  }

  _goToHistorytest() async {
    chatBot.stateStream.listen((state) async {
      if (state.id == "E") {
        await Future.delayed(const Duration(seconds: 3));
        Map<String, dynamic> historymap = await chatBot.getMessageHistoryMap();
        ChatBot chatBotFromHistory = ChatBot.fromMessageHistoryMap(historymap);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HistoryTest(
              chatbot: chatBotFromHistory,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My ChatBot"),
        centerTitle: true,
      ),
      body: ChatBotWidget(
        chatBot: chatBot,
        sameUserSpacing: 3,
      ),
    );
  }
}

class HistoryTest extends StatefulWidget {
  final ChatBot chatbot;

  const HistoryTest({
    Key? key,
    required this.chatbot,
  }) : super(key: key);

  @override
  State<HistoryTest> createState() => _HistoryTestState();
}

class _HistoryTestState extends State<HistoryTest> {
  @override
  Widget build(BuildContext context) {
    return ChatBotWidget(
      chatBot: widget.chatbot,
      sameUserSpacing: 3,
    );
  }
}
