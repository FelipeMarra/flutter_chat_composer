library flutter_chat_composer;

import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/utils/check_box_widget.dart';

import 'models/chat_bot_models.dart';
import 'widgets/bot_message_widget.dart';
import 'widgets/bot_user_open_text.dart';
import 'widgets/user_message_widget.dart';

export 'models/chat_bot_models.dart';
export 'widgets/bot_message_widget.dart';
export 'widgets/user_message_widget.dart';
export 'widgets/bot_user_open_text.dart';

class ChatBotWidget extends StatefulWidget {
  ///The [ChatBot] that will generate the chat
  final ChatBot chatBot;

  ///Widget that displays the [Message]s of the bot, see each group of messages
  ///ass a paragraph
  final BotMessageWidget Function(RichText message)? botMessageWidget;

  ///Widget that displays the [Message] of each transition option
  final Widget Function(RichText message) botTransitionWidget;

  ///Widget that displays the [Message] related to the transition choosen by the user
  final Widget Function(RichText message)? userMessageWidget;

  ///Widget that captures the text the user typed when the state type is [BotStateOpenText]
  final BotUserOpenText? userOpenTextWidget;

  ///A state of the [ChatBot] that will allow to select multiple choices as the answer
  //TODO final MultipleCheckboxFormField Function(BotStateCheckBox currentState)?
  //    botMultipleChoiceMessage;

  ///SizedBox hight between messages of the same user
  final double? sameUserSpacing;

  ///SizedBox hight betweewn messagen of different users
  final double? difUsersSpacing;

  const ChatBotWidget({
    Key? key,
    required this.chatBot,
    this.botMessageWidget,
    required this.botTransitionWidget,
    this.userMessageWidget,
    this.sameUserSpacing,
    this.difUsersSpacing,
    this.userOpenTextWidget,
    //this.botMultipleChoiceMessage,
  }) : super(key: key);

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget> {
  List<Widget> chatWidgets = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.chatBot.stateStream,
      builder: (context, AsyncSnapshot<BotState> snapshot) {
        if (snapshot.data == null) {
          return Container();
        }

        _processSnapshot(snapshot);

        //display the messages
        return Scaffold(
          body: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: chatWidgets.length,
              itemBuilder: (context, index) {
                return chatWidgets[index];
              },
            ),
          ),
        );
      },
    );
  }

  _processSnapshot(AsyncSnapshot<BotState> snapshot) async {
    BotState currentState = snapshot.data!;
    //get message and options data
    //add them to the messages' list
    List<RichText> messages = currentState.messages();
    for (RichText message in messages) {
      chatWidgets.add(
        widget.botMessageWidget != null
            ? widget.botMessageWidget!(message)
            //default widget
            : BotMessageWidget(message: message),
      );

      chatWidgets.add(SizedBox(height: widget.sameUserSpacing));
    }

    //test the text type we're dealing with
    if (currentState.runtimeType == BotStateOpenText) {
      _processOpenText(currentState as BotStateOpenText);
    } else if (currentState.runtimeType == BotStateMultipleChoice) {
      _processMultipleChoice(currentState as BotStateMultipleChoice);
    } else {
      _processSingleChoice(currentState);
    }

    chatWidgets.add(SizedBox(height: widget.difUsersSpacing));
  }

  _processMultipleChoice(BotStateMultipleChoice currentState) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    //default widget
    chatWidgets.add(
      Form(
        key: _formKey,
        child: MultipleCheckboxFormField(
          options: currentState.options,
          onChangeAll: (indexes) {
            for (int index in indexes) {
              BotOption currentOption = currentState.options[index];
              if (currentOption.onChange != null) {
                currentOption.onChange!(currentOption);
              }
            }
          },
          onFinalize: (List<int> indexes) {
            //validation
            if (_formKey.currentState?.validate() == false) {
              return;
            }
            //convert in user answer
            List<BotOption> options = [];
            for (int index in indexes) {
              BotOption currentOption = currentState.options[index];
              options.add(currentOption);
              //add transition messages a the user's answer
              chatWidgets.add(
                widget.userMessageWidget != null
                    ? widget.userMessageWidget!(currentOption.message!)
                    //default widget
                    : UserMessageWidget(message: currentOption.message!),
              );
            }
            String nextState = currentState.decideTransition(options);
            widget.chatBot.transitionTo(nextState);

            //dipose key
            _formKey.currentState!.dispose();
          },
        ),
      ),
    );
  }

  _processOpenText(BotStateOpenText currentState) {
    //add open user's text widget
    chatWidgets.add(
      IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: widget.userOpenTextWidget ??
                  //default widget
                  BotUserOpenText(
                    chatBot: widget.chatBot,
                    userMessageWidget: (message) =>
                        UserMessageWidget(message: message),
                    controller: TextEditingController(),
                    icon: const Icon(Icons.send),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  _processSingleChoice(currentState) {
    List<BotTransition> transitions = currentState.transitions;
    //process & add each bot transition
    for (var i = 0; i < transitions.length; i++) {
      BotTransition transition = transitions[i];

      chatWidgets.add(
        InkWell(
          child: widget.botTransitionWidget(transition.message!),
          onTap: () {
            //add transition messages a the user's answer
            chatWidgets.add(
              widget.userMessageWidget != null
                  ? widget.userMessageWidget!(transition.message!)
                  //default widget
                  : UserMessageWidget(message: transition.message!),
            );
            chatWidgets.add(SizedBox(height: widget.difUsersSpacing));
            //run the transition
            widget.chatBot.transitionTo(transition.to);
          },
        ),
      );
      //Add spacing to all but the last transition
      if (i != transitions.length - 1) {
        chatWidgets.add(SizedBox(height: widget.sameUserSpacing));
      }
    }
  }
}
