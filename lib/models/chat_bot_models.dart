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
  final List<RichText> messages;

  ///TODO: Time to wait between showing [messages]
  //final Duration displayInterval;

  BotState({
    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    List<BotTransition>? transitions,
    required this.messages,

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

  BotStateOpenText({
    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    required List<BotTransition> transitions,

    ///A message is a list of texts, each messagem is showed separated
    required List<RichText> messages,
    required this.decideTransition,

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
