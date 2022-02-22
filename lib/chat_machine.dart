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
  //TODO Make as a list of paragraphs, a paragraph is a list of texts
  //that are in the same message, each messagem is showed separated
  final List<Paragraph> messages;

  BotState({
    required String id,
    required List<BotOption> options,
    required this.messages,
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

class Paragraph {
  List<Text> texts;
  Paragraph({
    required this.texts,
  });
}
