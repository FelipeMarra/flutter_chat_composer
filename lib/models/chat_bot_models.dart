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

class BotState extends ComposerState {
  ///A message is a list of texts, each messagem is showed separated
  final List<Message> messages;
  ///Time to wait between showing [messages]
  final Duration displayInterval;

  BotState({
    required String id,
    required List<BotOption> options,
    required this.messages,
    this.displayInterval = const Duration(seconds: 1),
    final Function(ComposerState? lastState, ComposerState currentState)?
        onEnter,
    final Function(ComposerState currentState, ComposerState nextState)?
        onLeave,
  }) : super(
          id: id,
          transitions: options,
          onEnter: onEnter,
          onLeave: onLeave,
        );
}

class BotOption extends Transition {
  BotOption({
    required String id,
    required String to,
    required Text optionText,
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
