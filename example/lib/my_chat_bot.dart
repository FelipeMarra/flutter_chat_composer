import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/models/chat_bot_models.dart';

class MyChatBot {
  ChatBot _chatBot() {
    return ChatBot(
      id: "myChatBot",
      initialStateId: "A",
      states: [
        _stateA(),
        _stateB(),
        _stateC(),
        _stateD(),
        _stateE(),
      ],
    );
  }

  ChatBot get chatBot => _chatBot();

  BotStateOpenText _stateA() {
    return BotStateOpenText(
      id: "A",
      messages: () => [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: "Wellcome to "),
              TextSpan(
                text: "State A.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        RichText(
          text: const TextSpan(
              text:
                  "If you say something you're going to single choice state B, else you're going to openText satate c?"),
        ),
      ],
      transitions: [
        BotTransition(
          id: "A=>B",
          to: "B",
        ),
        BotTransition(
          id: "A=>C",
          to: "C",
        ),
      ],
      decideTransition: (textController) {
        if (textController.text.isNotEmpty) {
          return "B";
        } else {
          return "C";
        }
      },
      onEnter: (machine) {
        print("Entered ${machine.currentState!.id}");
      },
      onLeave: (machine, nextState) {
        print("Left ${machine.currentState!.id} going to ${nextState.id}");
      },
    );
  }

  BotState _stateB() {
    return BotState(
      id: "B",
      messages: () => [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: "Ok, so now you're in "),
              TextSpan(
                text: "State B!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        RichText(
          text: const TextSpan(text: "Where do you wanna go next?"),
        ),
      ],
      transitions: [
        BotTransition(
          id: "B=>D",
          to: "D",
          message: RichText(
            text: const TextSpan(text: "Go from B to D"),
          ),
        ),
        BotTransition(
          id: "B=>E",
          to: "E",
          message: RichText(
            text: const TextSpan(text: "Go from B to E"),
          ),
        ),
      ],
      onEnter: (machine) {
        print("Entered ${machine.currentState!.id}");
      },
    );
  }

  BotStateMultipleChoice _stateC() {
    return BotStateMultipleChoice(
        id: "C",
        messages: () => [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(text: "Ok, so now you're in "),
                    TextSpan(
                      text: "State C! ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "As in Cool State"),
                  ],
                ),
              ),
              RichText(
                text: const TextSpan(text: "Where do you wanna go next?"),
              ),
              RichText(
                text: const TextSpan(text: "Just making it bigger"),
              ),
              RichText(
                text: const TextSpan(text: "Even"),
              ),
              RichText(
                text: const TextSpan(text: "Even bigger"),
              ),
            ],
        options: [
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Option 1"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Option 2"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Option 3"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Option 4"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Option 5"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Option 6"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Option 7"),
            ),
          ),
        ],
        transitions: [
          BotTransition(
            id: "C=>D",
            to: "D",
          ),
          BotTransition(
            id: "C=>E",
            to: "E",
          ),
        ],
        decideTransition: (options) {
          if (options.length > 1) {
            return "D";
          } else {
            return "E";
          }
        });
  }

  BotState _stateD() {
    return BotState(
      id: "D",
      messages: () => [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: "I'm tyred of creating states. "),
              TextSpan(
                text: "State D ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: "Is the last one"),
            ],
          ),
        ),
      ],
      onEnter: (machine) {
        print("Entered ${machine.currentState!.id}");
      },
    );
  }

  BotState _stateE() {
    return BotState(
      id: "E",
      messages: () => [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: "I'm tyred of creating states. "),
              TextSpan(
                text: "State E ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: "Is the last one"),
            ],
          ),
        ),
      ],
      onEnter: (machine) {
        print("Entered ${machine.currentState!.id}");
      },
    );
  }
}
