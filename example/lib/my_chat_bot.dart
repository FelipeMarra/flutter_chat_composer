import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

class MyChatBot {
  static String botName = "A COOL BOT";
  static String userName = "";
  static String choosenPokemonGif = "";

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
          onChange: (option) => choosenPokemonGif =
              "https://i.pinimg.com/originals/62/a6/94/62a694968a8a3a1842c4b9a79d5aa5c1.gif",
        ),
        BotOption(
          message: const Text("Charmander"),
          onChange: (option) => choosenPokemonGif =
              "https://i.pinimg.com/originals/37/08/62/370862bbff7f3d3345a3d0e9b45a38c3.gif",
        ),
        BotOption(
          message: const Text("Squirtle"),
          onChange: (option) => choosenPokemonGif =
              "https://i.pinimg.com/originals/24/e2/e7/24e2e7c933f4f0f11dac65521a9c4a29.gif",
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
      id: "C",
      image: () => Image.network(choosenPokemonGif),
      onEnter: (machine) async {
        await Future.delayed(const Duration(seconds: 1));
        //machine.transitionTo("D");
      },
      transition: BotTransition(id: "C=>D", to: "D"),
    );
  }
}
