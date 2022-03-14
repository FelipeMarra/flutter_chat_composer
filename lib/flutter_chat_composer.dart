library flutter_chat_composer;

import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/utils/check_box_widget.dart';
import 'package:flutter_chat_composer/widgets/bot_image_widget.dart';
import 'package:flutter_chat_composer/widgets/bot_single_choice_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'models/chat_bot_models.dart';
import 'widgets/bot_message_widget.dart';
import 'widgets/bot_user_open_text.dart';
import 'widgets/user_message_widget.dart';

export 'models/chat_bot_models.dart' hide BotState;
export 'widgets/bot_message_widget.dart';
export 'widgets/user_message_widget.dart';
export 'widgets/bot_user_open_text.dart';

class ChatBotWidget extends StatefulWidget {
  ///The [ChatBot] that will generate the chat
  final ChatBot chatBot;

  ///Widget that displays the [Message]s of the bot, see each group of messages
  ///ass a paragraph
  final BotMessageWidget Function(Text message)? botMessageWidget;

  ///Widget that displays the [Message] of each transition option
  final Widget Function(Text message)? botSingleChoiceWidget;

  ///Widget that displays the [Message] related to the transition choosen by the user
  final Widget Function(Text message)? userMessageWidget;

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
    this.botSingleChoiceWidget,
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
  final ItemScrollController _scrollController = ItemScrollController();
  List<BotState> history = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.chatBot.stateStream,
      builder: (context, AsyncSnapshot<BotState> snapshot) {
        bool conection = snapshot.connectionState == ConnectionState.active;
        if (conection && snapshot.hasData) {
          history.add(snapshot.data!);

          _scrollToLast();

          //display the messages
          return ScrollablePositionedList.separated(
            shrinkWrap: true,
            itemScrollController: _scrollController,
            itemCount: history.length,
            itemBuilder: _itemBuilder,
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: widget.difUsersSpacing,
            ),
          );
        }

        return Container();
      },
    );
  }

  void _scrollToLast() async {
    if (_scrollController.isAttached) {
      await Future.delayed(const Duration(milliseconds: 5));
      _scrollController.scrollTo(
        index: history.length - 1,
        duration: const Duration(milliseconds: 400),
      );
    }
  }

  Column _itemBuilder(context, index) {
    BotState currentState = history[index];
    Type currentType = currentState.runtimeType;
    List<Widget> widgets = [];

    if (currentType != BotStateImage) {
      //get message and options data
      List<Text> messages = currentState.messages();
      //add them to the messages' list
      for (Text message in messages) {
        widgets.add(
          widget.botMessageWidget != null
              ? widget.botMessageWidget!(message)
              //default widget
              : BotMessageWidget(message: message),
        );

        widgets.add(SizedBox(height: widget.sameUserSpacing));
      }
    }

    if (currentType == BotStateOpenText) {
      widgets.add(_processOpenText(currentState as BotStateOpenText));
    } else if (currentType == BotStateMultipleChoice) {
      widgets.addAll(
        _processMultipleChoice(currentState as BotStateMultipleChoice),
      );
    } else if (currentType == BotStateImage) {
      widgets.addAll(_processImage(currentState as BotStateImage));
    } else {
      widgets.addAll(
        _processSingleChoice(currentState as BotStateSingleChoice),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  List<Widget> _processMultipleChoice(BotStateMultipleChoice currentState) {
    List<Widget> widgets = [];
    bool enabled = currentState.optionsSelectedByUser.isEmpty;

    if (enabled) {
      final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
      //default widget
      widgets.add(
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
              if (_formKey.currentState!.validate()) {
                List<BotOption> options = [];

                for (int index in indexes) {
                  options.add(currentState.options[index]);
                  currentState.optionsSelectedByUser.add(index);
                  currentState.optionsSelectedByUser.sort();
                }

                String nextState = currentState.decideTransition(options);
                widget.chatBot.transitionTo(nextState);

                return true;
              } else {
                return false;
              }
            },
          ),
        ),
      );
    } else {
      for (int index in currentState.optionsSelectedByUser) {
        BotOption currentOption = currentState.options[index];

        //add transition messages as the user's answer
        widgets.add(
          widget.userMessageWidget != null
              ? widget.userMessageWidget!(currentOption.message!)
              //default widget
              : UserMessageWidget(message: currentOption.message!),
        );

        widgets.add(SizedBox(height: widget.sameUserSpacing));
      }
    }
    return widgets;
  }

  Widget _processOpenText(BotStateOpenText currentState) {
    //add open user's text widget
    //TODO optimize to rebuild so we dont have to create a new controller etc
    TextEditingController controller = TextEditingController(
      text: currentState.userText,
    );

    Widget child = IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: widget.userOpenTextWidget ??
                //default widget
                BotUserOpenText(
                  wasPressed: currentState.userText.isNotEmpty,
                  chatBot: widget.chatBot,
                  userMessageWidget: (message) =>
                      UserMessageWidget(message: message),
                  controller: controller,
                  icon: const Icon(Icons.send),
                ),
          ),
        ],
      ),
    );

    controller.addListener(() => currentState.userText = controller.text);

    return child;
  }

  List<Widget> _processImage(BotStateImage currentState) {
    List<Widget> widgets = [];
    widgets.add(
      BotImageWidget(
        label: currentState.label(),
        image: currentState.image(),
      ),
    );
    widgets.add(SizedBox(height: widget.sameUserSpacing));
    return widgets;
  }

  List<Widget> _processSingleChoice(BotStateSingleChoice currentState) {
    List<Widget> widgets = [];
    bool enabled = currentState.userSelectedMessage.isNegative;

    if (enabled) {
      List<BotTransition> transitions = currentState.transitions;
      //process & add each bot transition
      for (var i = 0; i < transitions.length; i++) {
        BotTransition transition = transitions[i];

        if (transition.message != null) {
          Text message = transition.message!;
          Widget child;
          if (widget.botSingleChoiceWidget != null) {
            child = widget.botSingleChoiceWidget!(message);
          } else {
            child = BotSingleChoiceWidget(
              message: message,
              onPress: () {
                //save the answer
                currentState.userSelectedMessage = i;
                //run the transition
                widget.chatBot.transitionTo(transition.to);
              },
            );
          }
          widgets.add(child);
          //Add spacing to all but the last transition
          if (i != transitions.length - 1) {
            widgets.add(SizedBox(height: widget.sameUserSpacing));
          }
        }
      }
    } else {
      //add transition messages a the user's answer
      int index = currentState.userSelectedMessage;
      Text message = currentState.transitions[index].message!;
      widgets.add(
        widget.userMessageWidget != null
            ? widget.userMessageWidget!(message)
            //default widget
            : UserMessageWidget(message: message),
      );
      widgets.add(SizedBox(height: widget.difUsersSpacing));
    }

    return widgets;
  }
}
