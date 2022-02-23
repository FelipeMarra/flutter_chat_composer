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
            )
          ],
        ),
      ),
    );
  }
}
