library flutter_chat_composer;

import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/widgets/bot_multiple_choice_form.dart/bot_multiple_choice_form.dart';
import 'package:flutter_chat_composer/widgets/bot_multiple_choice_form.dart/check_box_widget.dart';
import 'package:flutter_chat_composer/widgets/bot_image_widget.dart';
import 'package:flutter_chat_composer/widgets/default_widgets/bot_single_choice_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'models/chat_bot_models.dart';
import 'widgets/default_widgets/bot_message_widget.dart';
import 'widgets/bot_user_open_text.dart';
import 'widgets/default_widgets/user_message_widget.dart';

export 'models/chat_bot_models.dart' hide BotState;
export 'widgets/default_widgets/bot_message_widget.dart';
export 'widgets/default_widgets/user_message_widget.dart';
export 'widgets/bot_user_open_text.dart';

class ChatBotWidget extends StatefulWidget {
  ///The [ChatBot] that will generate the chat
  final ChatBot chatBot;

  ///Widget that displays a bot message
  final BotMessageWidget Function(Text message)? botMessageWidget;

  ///Widget that displays a user message
  final Widget Function(Text message)? userMessageWidget;

  ///Widget that displays a option from [BotStateSingleChoice]
  final Widget Function(Text message)? botSingleChoiceWidget;

  ///Widget to recive user's selection when displaying [BotStateMultipleChoice]
  final MultipleCheckboxFormField? multipleCheckboxFormField;

  ///Widget to recive user's text when displaying [BotStateOpenText]
  final BotUserOpenText? userOpenTextWidget;

  ///Widget to receive the iamge when displaying [BotStateImage]
  final Widget Function(Image image, List<Text>? label)? botImageWidget;

  ///SizedBox hight between messages of the same user
  final double? sameUserSpacing;

  ///SizedBox hight betweewn messagen of different users
  final double? difUsersSpacing;

  const ChatBotWidget({
    Key? key,
    required this.chatBot,
    this.botMessageWidget,
    this.userMessageWidget,
    this.botSingleChoiceWidget,
    this.multipleCheckboxFormField,
    this.userOpenTextWidget,
    this.botImageWidget,
    this.sameUserSpacing,
    this.difUsersSpacing,
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
            padding: const EdgeInsets.all(10),
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
      List<Text> messages = currentState.messages!();
      //add messages to the widgets list
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

    //handle diffent types of states
    if (currentType == BotStateOpenText) {
      widgets.add(_processOpenText());
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

    //if enabled show options for user to select, else show user's answer
    bool enabled = currentState.optionsSelectedByUser.isEmpty;

    if (enabled) {
      widgets.add(
        BotMultipleChoiceFormWidget(
          chatBot: widget.chatBot,
          multipleCheckboxFormField: widget.multipleCheckboxFormField,
          validator: currentState.validator,
        ),
      );
    } else {
      //add selected options messages as the user's answer
      for (int index in currentState.optionsSelectedByUser) {
        BotOption currentOption = currentState.options()[index];

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

  Widget _processOpenText() {
    //add open user's text widget
    Widget child = widget.userOpenTextWidget ??
        //default widget
        BotUserOpenText(
          chatBot: widget.chatBot,
          userMessageWidget: (message) => UserMessageWidget(message: message),
        );

    return child;
  }

  List<Widget> _processImage(BotStateImage currentState) {
    List<Widget> widgets = [];

    Widget child;
    if (widget.botImageWidget != null) {
      child = widget.botImageWidget!(
        currentState.image(),
        currentState.label != null ? currentState.label!() : null,
      );
    } else {
      child = BotImageWidget(
        image: currentState.image(),
        label: currentState.label != null ? currentState.label!() : null,
      );
    }
    widgets.add(child);

    widgets.add(SizedBox(height: widget.sameUserSpacing));

    return widgets;
  }

  List<Widget> _processSingleChoice(BotStateSingleChoice currentState) {
    List<Widget> widgets = [];
    if (currentState.options != null) {
      bool enabled = currentState.userSelectedOption.isNegative;

      //if enabled show options for user to select, else show user's answer
      if (enabled) {
        List<BotOption> options = currentState.options!;
        //process & add each bot transition
        for (var i = 0; i < options.length; i++) {
          BotOption option = options[i];

          if (option.message != null) {
            Text message = option.message!;

            Widget child;
            if (widget.botSingleChoiceWidget != null) {
              child = widget.botSingleChoiceWidget!(message);
            } else {
              child = BotSingleChoiceWidget(message);
            }

            widgets.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: InkWell(
                      highlightColor: Colors.grey[100],
                      onTap: () {
                        if (option.onChange != null) {
                          option.onChange!(option);
                        }
                        //save the answer
                        currentState.userSelectedOption = i;
                        //run the transition
                        if (currentState.decideTransition != null) {
                          String state = currentState.decideTransition!(option);
                          widget.chatBot.transitionTo(state);
                        }
                      },
                      child: child,
                    ),
                  ),
                ],
              ),
            );
            //Add spacing to all but the last transition
            if (i != options.length - 1) {
              widgets.add(SizedBox(height: widget.sameUserSpacing));
            }
          }
        }
      } else {
        //add transition messages a the user's answer
        int index = currentState.userSelectedOption;
        Text message = currentState.options![index].message!;
        widgets.add(
          widget.userMessageWidget != null
              ? widget.userMessageWidget!(message)
              //default widget
              : UserMessageWidget(message: message),
        );
        widgets.add(SizedBox(height: widget.difUsersSpacing));
      }
    }
    return widgets;
  }
}
