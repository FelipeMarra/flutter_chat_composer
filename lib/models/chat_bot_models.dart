import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:state_composer/state_composer.dart';

///A [StateMachine] that represents the chat bot
class ChatBot extends StateMachine<BotStateBase> {
  ChatBot({
    required String id,
    required List<BotStateBase> states,
    required String initialStateId,
  }) : super(
          id: id,
          states: states,
          initialStateId: initialStateId,
        );
}

///The base class of the  [ChatBot]'s states
class BotStateBase extends ComposerState<BotTransition> {
  BotStateBase({
    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    List<BotTransition>? transitions,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotStateBase nextState)? onLeave,
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
              onLeave(machine as ChatBot, nextState as BotStateBase);
            }
          },
        );
}

///A state of the [ChatBot] that allows user to choose one option in a menu generated
///using its transitions list (the option message is the transition message)
class BotStateSingleChoice extends BotStateBase {
  ///Options that will be displayed
  final List<BotOption>? options;

  ///Function that will take the user's selection and return to what state that
  ///the bot will go to
  final String Function(BotOption selectedOption)? decideTransition;

  ///Message selected by the user, for storage purposes
  int userSelectedOption;

  ///A a list of [MarkdownBody], each message is showed separated
  final List<MarkdownBody> Function() messages;

  BotStateSingleChoice({
    this.options,
    this.userSelectedOption = -1,
    this.decideTransition,
    required this.messages,

    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    List<BotTransition>? transitions,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotStateBase nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transitions,
          onEnter: onEnter,
          onLeave: onLeave,
        );
}

///A state of the [ChatBot] that will display a image and have no user interaction
///(use onEnter or onLeave to perform some login to go to the next state like a [Future.delayed])
class BotStateImage extends BotStateBase {
  ///Image to be displayed
  final Image Function() image;

  ///[image]'s label
  final List<MarkdownBody> Function()? label;

  BotStateImage({
    required this.image,
    this.label,

    ///The state's name (it's unique identifier)
    required String id,

    ///Transition to go to the other state
    BotTransition? transition,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotStateBase nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transition != null ? [transition] : [],
          onEnter: onEnter,
          onLeave: onLeave,
        );
}

///A state of the [ChatBot] that will have a open text as the user's answer
class BotStateOpenText extends BotStateBase {
  ///Function that will take the user's input and return to what state the bot
  ///will go
  String Function(TextEditingController textController) decideTransition;

  ///Text typed by the user, for storage purposes
  String userText = "";

  ///A a list of [MarkdownBody], each message is showed separated
  final List<MarkdownBody> Function() messages;

  BotStateOpenText({
    required this.decideTransition,
    required this.messages,

    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    required List<BotTransition> transitions,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotStateBase nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transitions,
          onEnter: onEnter,
          onLeave: onLeave,
        );
}

///A state of the [ChatBot] that will allow to select multiple choices as the answer
class BotStateMultipleChoice extends BotStateBase {
  ///Function that will take the user's selection and return to what state that
  ///the bot will go to
  final String Function(List<BotOption> selectedOptions) decideTransition;

  ///Options that will be displayed
  final List<BotOption> Function() options;

  ///Options the user selected, for storage purposes
  List<int> optionsSelectedByUser = [];

  ///To validade the options
  final String? Function(List<BotOption>)? validator;

  ///A a list of [MarkdownBody], each message is showed separated
  final List<MarkdownBody> Function() messages;

  BotStateMultipleChoice({
    required this.options,
    required this.decideTransition,
    required this.messages,
    this.validator,

    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    required List<BotTransition> transitions,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotStateBase nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transitions,
          onEnter: onEnter,
          onLeave: onLeave,
        );
}

///Represents a [BotStateMultipleChoice] option
class BotOption {
  ///Option text
  final MarkdownBody? message;

  ///Call back for when this option is selected or unselected
  final Function(BotOption option)? onChange;

  ///If the option is currently selected, defaults to false
  bool selected;

  BotOption({
    required this.message,
    this.onChange,
    this.selected = false,
  });
}

///A transition [to] another [BotState]
///Should receive a message if it's a [BotStateSingleChoice]'s transition
class BotTransition extends Transition {
  BotTransition({
    required String id,
    required String to,
  }) : super(
          id: id,
          to: to,
        );
}
