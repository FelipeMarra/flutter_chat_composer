import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

class MyChatBot {
  static String botName = "A COOL BOT";
  static String userName = "";
  static String choosenPokemoGif = "";

  ChatBot chatBot() {
    return ChatBot(
      id: "chat_bot",
      initialStateId: "A",
      states: [
        _stateA(),
        _stateALoop(),
        _stateB(),
        _stateC(),
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
              TextSpan(text: "I reaally need to know your name... "),
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

  BotStateSingleChoice _stateB() {
    return BotStateSingleChoice(
      id: "B",
      messages: () => [
        Text.rich(
          TextSpan(text: "Ok, $userName what pokemon would you choose"),
        )
      ],
      options: [
        BotOption(
          message: const Text("Bulbassaur"),
          onChange: (option) => choosenPokemoGif =
              "https://c.tenor.com/38wTyIwrukEAAAAC/bulbasaur.gif",
        ),
        BotOption(
          message: const Text("Charmander"),
          onChange: (option) => choosenPokemoGif =
              "https://c.tenor.com/g9g8zfVwElUAAAAM/pokemon-charmander.gif",
        ),
        BotOption(
          message: const Text("Squirtle"),
          onChange: (option) => choosenPokemoGif =
              "https://c.tenor.com/Ken3eHIfWnAAAAAC/pokemon-squirtle.gif",
        ),
      ],
      transitions: [
        BotTransition(id: "B=>C", to: "C"),
      ],
      decideTransition: (BotOption selectedOptions) => "C",
    );
  }

  BotStateImage _stateC() {
    return BotStateImage(
      image: () => Image.network(choosenPokemoGif),
      id: "C",
    );
  }
}
