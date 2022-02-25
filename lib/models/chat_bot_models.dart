import 'package:flutter/material.dart';
import 'package:state_composer/state_composer.dart';

class ChatBot extends StateMachine<BotState> {
  ChatBot({
    required String id,
    required List<BotState> states,
    required String initialStateId,
  }) : super(
          id: id,
          states: states,
          initialStateId: initialStateId,
        );
}

class BotState extends ComposerState<BotTransition> {
  ///A message is a list of texts, each messagem is showed separated
  final List<Message> messages;

  ///Time to wait between showing [messages]
  final Duration displayInterval;

  BotState({
    required String id,
    required List<BotTransition> transitions,
    required this.messages,
    this.displayInterval = const Duration(seconds: 1),
    Function(ChatBot stateMachine)? onEnter,
    Function(ChatBot chatBot, BotState nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transitions,
          onEnter: (machine) {
            if (onEnter != null) {
              onEnter(machine as ChatBot);
            }
          },
          onLeave: (machine, nextState) {
            if (onLeave != null) {
              onLeave(machine as ChatBot, nextState as BotState);
            }
          },
        );
}

class BotTransition extends Transition {
  final Message message;

  BotTransition({
    required String id,
    required String to,
    required this.message,
  }) : super(
          id: id,
          to: to,
        );
}

class Message {
  List<Text> texts;
  Message({
    required this.texts,
  });
}