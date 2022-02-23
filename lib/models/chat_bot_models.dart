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

class BotState extends ComposerState<BotOption> {
  ///A message is a list of texts, each messagem is showed separated
  final List<Message> messages;

  ///Time to wait between showing [messages]
  final Duration displayInterval;

  final Function(ChatBot stateMachine)? onEnterState;
  final Function(ChatBot chatBot, BotState nextState)? onLeaveState;

  BotState({
    required String id,
    required List<BotOption> options,
    required this.messages,
    this.displayInterval = const Duration(seconds: 1),
    this.onEnterState,
    this.onLeaveState,
  }) : super(
            id: id,
            transitions: options,
            onEnter: (machine) {
              if (onEnterState != null) {
                onEnterState(machine as ChatBot);
              }
            },
            onLeave: (machine, nextState) {
              if (onLeaveState != null) {
                onLeaveState(machine as ChatBot, nextState as BotState);
              }
            });
}

class BotOption extends Transition {
  final Text optionText;

  BotOption({
    required String id,
    required String to,
    required this.optionText,
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
