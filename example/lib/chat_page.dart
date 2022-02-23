import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/models/chat_bot_models.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("APP"),
      ),
      body: ChatBotWidget(
        botMessageWidget: (paragraph) {
          return Container(
            color: Colors.red,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: paragraph.texts,
            ),
          );
        },
        botOptionWidget: (text) {
          return Container(
            color: Colors.purple,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [text],
            ),
          );
        },
        userMessageWidget: (text) {
          return Container(
            color: Colors.blue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [text],
            ),
          );
        },
        chatBot: ChatBot(
          id: "myChatBot",
          initialStateId: "A",
          states: [
            BotState(
              id: "A",
              messages: [
                Message(
                  texts: [
                    const Text("Hello you're in state A"),
                  ],
                ),
              ],
              options: [
                BotOption(
                  id: "A=>B",
                  to: "B",
                  optionText: const Text("Go from A to B"),
                ),
              ],
              onEnterState: (machine) {
                print("ENTROU NO ${machine.currentState!.id}");
              },
              onLeaveState: (machine, nextState) {
                print(
                    "Saiu de ${machine.currentState!.id} indo para ${nextState.id}");
              },
            ),
            BotState(
              id: "B",
              messages: [
                Message(
                  texts: [
                    const Text("Ok, now you're in state B"),
                  ],
                ),
              ],
              options: [
                BotOption(
                  id: "B",
                  to: "A",
                  optionText: const Text("Go from A to B"),
                ),
              ],
              onEnterState: (machine) {
                print("ENTROU NO ${machine.currentState!.id}");
              },
            )
          ],
        ),
      ),
    );
  }
}
