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
        _stateD(),
        _stateE(),
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
              TextSpan(text: "I reeeally  need to know your name..."),
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
        Text("Ok, $userName what pokemon would you choose"),
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
        machine.transitionTo("D");
      },
      transition: BotTransition(id: "C=>D", to: "D"),
    );
  }

  BotStateMultipleChoice _stateD() {
    return BotStateMultipleChoice(
      id: "D",
      messages: () => [
        const Text("That was a wise choice!"),
        const Text("What 3 other pokemons you like most?"),
      ],
      options: () => [
        BotOption(message: const Text("Pikachu")),
        BotOption(message: const Text("Eevee")),
        BotOption(message: const Text("Charizard")),
        BotOption(message: const Text("Mewtwo")),
        BotOption(message: const Text("Gengar")),
        BotOption(message: const Text("Lucario")),
      ],
      validator: (options) {
        if (options.length != 3) {
          return "Select 3 options";
        }
        return null;
      },
      transitions: [
        BotTransition(id: "D=>E", to: "E"),
      ],
      decideTransition: (options) => "E",
    );
  }

  BotStateSingleChoice _stateE() {
    return BotStateSingleChoice(
      id: "E",
      messages: () => [
        const Text("Very interesting choices!"),
        Text("Bye bye, $userName, it was nice talking to you!"),
      ],
    );
  }
}
