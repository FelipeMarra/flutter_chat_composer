import 'package:flutter/material.dart';
import 'package:state_composer/state_composer.dart';

///A [StateMachine] that represents the chat bot
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

//TODO support to async get messages
///Each state of the [ChatBot] that is composed of predetermined transitions
///to be displayed in a menu style
class BotState extends ComposerState<BotTransition> {
  ///A message is a list of texts, each messagem is showed separated
  final List<RichText> Function() messages;

  ///Message selected by the user for storage purposes
  final int? userSelectedMessage;

  ///TODO: Time to wait between showing [messages]
  //final Duration displayInterval;
  BotState({
    required this.messages,
    this.userSelectedMessage,

    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    List<BotTransition>? transitions,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotState nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transitions ?? [],
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

///A state of the [ChatBot] that will have a open text as the user's answer
class BotStateOpenText extends BotState {
  ///Function that will take the user's input and return to what state the bot
  ///will go
  String Function(TextEditingController textController) decideTransition;

  ///Text typed by the user for storage purposes
  String userText = "";

  BotStateOpenText({
    required this.decideTransition,

    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    required List<BotTransition> transitions,

    ///A message is a list of texts, each messagem is showed separated
    required List<RichText> Function() messages,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotState nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transitions,
          messages: messages,
          onEnter: onEnter,
          onLeave: onLeave,
        );
}

///A state of the [ChatBot] that will allow to select multiple choices as the answer
class BotStateMultipleChoice extends BotState {
  ///Function that will take the user's selection and return to what state that
  ///the bot will go to
  final String Function(List<BotOption> selectedOptions) decideTransition;

  ///Options that will be displayed
  final List<BotOption> options;

  ///Options the user selected for storage purposes
  List<int> optionsSelectedByUser = [];

  BotStateMultipleChoice({
    required this.options,
    required this.decideTransition,

    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    required List<BotTransition> transitions,

    ///A message is a list of texts, each messagem is showed separated
    required List<RichText> Function() messages,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotState nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transitions,
          messages: messages,
          onEnter: onEnter,
          onLeave: onLeave,
        );
}

class BotOption {
  final RichText? message;
  final Function(BotOption option)? onChange;
  bool selected;

  BotOption({
    required this.message,
    this.onChange,
    this.selected = false,
  });
}

///A transition [to] another [BotState]
///Should receive a message if it's not an [BotStateOpenText]'s transition
class BotTransition extends Transition {
  final RichText? message;

  BotTransition({
    required String id,
    required String to,
    this.message,
  }) : super(
          id: id,
          to: to,
        );
}
