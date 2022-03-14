import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

class MyChatBot {
  static String botName = "A COOL BOT";
  static String userName = "";

  ChatBot chatBot() {
    return ChatBot(
      id: "chat_bot",
      initialStateId: "A",
      states: [
        _stateA(),
        _stateALoop(),
        _stateB(),
      ],
    );
  }

  String _stateADecision(TextEditingController textController) {
    if (textController.text.isEmpty) {
      return "ALoop";
    } else {
      userName = textController.text;
      return "B";
    }
  }

  BotStateOpenText _stateA() {
    return BotStateOpenText(
      id: "A",
      messages: () => [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: "Hi, I'm "),
              TextSpan(
                children: [
                  TextSpan(
                      text: botName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              const TextSpan(
                children: [
                  TextSpan(text: ", what is your name ?"),
                ],
              ),
            ],
          ),
        ),
      ],
      transitions: [
        BotTransition(id: "A=>ALoop", to: "ALoop"),
        BotTransition(id: "A=>B", to: "B"),
      ],
      decideTransition: _stateADecision,
    );
  }

  BotStateOpenText _stateALoop() {
    return BotStateOpenText(
      id: "ALoop",
      messages: () => [
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "I reaally nedd to know your name... "),
            ],
          ),
        ),
      ],
      transitions: [
        BotTransition(id: "ALoop=>ALoop", to: "ALoop"),
        BotTransition(id: "ALoop=>B", to: "B"),
      ],
      decideTransition: (textController) {
        if (textController.text.isEmpty) {
          return "ALoop";
        } else {
          userName = textController.text;
          return "B";
        }
      },
    );
  }

  BotStateMultipleChoice _stateB() {
    return BotStateMultipleChoice(
      id: "B",
      messages: () => [

      ],
      options:  [

      ],
      transitions: [
        BotTransition(id: "B", to: "C"),
      ],
      decideTransition: (List<BotOption> selectedOptions) {
        return "";
      },
    );
  }
}
