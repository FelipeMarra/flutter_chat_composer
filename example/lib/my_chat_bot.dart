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

  BotState _stateA() {
    return BotState(
      id: "A",
      messages: [
        Message(texts: [
          const Text("Wellcome to "),
          const Text(
            "State A.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ]),
        Message(
          texts: [
            const Text("Tell me, what do you think about this state?"),
          ],
        ),
      ],
      transitions: [
        BotTransition(
          id: "A=>B",
          to: "B",
          transitionMessage: Message(
            texts: [
              const Text("Very cool!"),
            ],
          ),
        ),
        BotTransition(
          id: "A=>C",
          to: "C",
          transitionMessage: Message(
            texts: [
              const Text("I don't like this state"),
            ],
          ),
        ),
      ],
      onEnter: (machine) {
        print("Entered ${machine.currentState!.id}");
      },
      onLeave: (machine, nextState) {
        print("Left ${machine.currentState!.id} indo para ${nextState.id}");
      },
    );
  }

  BotState _stateB() {
    return BotState(
      id: "B",
      messages: [
        Message(
          texts: [
            const Text("Ok, so now you're in "),
            const Text(
              "State B!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Message(texts: [
          const Text("Where do you wanna go next?")
        ])
      ],
      transitions: [
        BotTransition(
          id: "B=>D",
          to: "D",
          transitionMessage: Message(texts: [
            const Text("Go from B to D"),
          ]),
        ),
        BotTransition(
          id: "B=>E",
          to: "E",
          transitionMessage: Message(texts: [
            const Text("Go from B to E"),
          ]),
        ),
      ],
      onEnter: (machine) {
        print("Entered ${machine.currentState!.id}");
      },
    );
  }

  BotState _stateC() {
    return BotState(
      id: "C",
      messages: [
        Message(
          texts: [
            const Text("Ok, so now you're in "),
            const Text(
              "State C! ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("As in Cool State"),
          ],
        ),
        Message(texts: [
          const Text("Where do you wanna go next?")
        ])
      ],
      transitions: [
        BotTransition(
          id: "C=>D",
          to: "C",
          transitionMessage: Message(texts: [
            const Text("Go from C to D"),
          ]),
        ),
        BotTransition(
          id: "C=>E",
          to: "E",
          transitionMessage: Message(texts: [
            const Text("Go from C to E"),
          ]),
        ),
      ],
      onEnter: (machine) {
        print("Entered ${machine.currentState!.id}");
      },
    );
  }

  BotState _stateD() {
    return BotState(
      id: "D",
      messages: [
        Message(
          texts: [
            const Text("I'm tyred of creating states. "),
            const Text(
              "State D ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("Is the last one"),
          ],
        ),
      ],
      transitions: [],
      onEnter: (machine) {
        print("Entered ${machine.currentState!.id}");
      },
    );
  }

  BotState _stateE() {
    return BotState(
      id: "E",
      messages: [
        Message(
          texts: [
            const Text("I'm tyred of creating states. "),
            const Text(
              "State E ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("Is the last one"),
          ],
        ),
      ],
      transitions: [],
      onEnter: (machine) {
        print("Entered ${machine.currentState!.id}");
      },
    );
  }
}
