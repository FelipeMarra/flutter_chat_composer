library flutter_chat_composer;

import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/widgets/bot_multiple_choice_form.dart/bot_multiple_choice_form.dart';
import 'package:flutter_chat_composer/widgets/bot_multiple_choice_form.dart/check_box_widget.dart';
import 'package:flutter_chat_composer/widgets/bot_image_widget.dart';
import 'package:flutter_chat_composer/widgets/bot_user_open_text/bot_user_open_text_controller.dart';
import 'package:flutter_chat_composer/widgets/default_widgets/bot_single_choice_widget.dart';
import 'package:flutter_chat_composer/widgets/bot_user_open_text/user_open_message_widget.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'models/chat_bot_models.dart';
import 'widgets/default_widgets/bot_message_widget.dart';
import 'widgets/bot_user_open_text/bot_user_open_text.dart';
import 'widgets/default_widgets/user_message_widget.dart';

export 'models/chat_bot_models.dart';
export 'widgets/default_widgets/bot_message_widget.dart';
export 'widgets/default_widgets/user_message_widget.dart';
export 'widgets/bot_user_open_text/bot_user_open_text.dart';

//TODO: Add a widget tht can be added at the end of the chat?
class ChatBotWidget extends StatelessWidget {
  ///The [ChatBot] that will generate the chat
  final ChatBot chatBot;

  ///Widget that displays a bot message
  final BotMessageWidget Function(MarkdownBody message)? botMessageWidget;

  ///Widget that displays a user message
  final Widget Function(MarkdownBody message)? userMessageWidget;

  ///Widget that displays a option from [BotStateSingleChoice]
  final Widget Function(MarkdownBody message)? botSingleChoiceWidget;

  ///Widget to recive user's selection when displaying [BotStateMultipleChoice]
  final MultipleCheckboxFormField? multipleCheckboxFormField;

  ///Widget to recive user's text when displaying [BotStateOpenText]
  final BotUserOpenText? userOpenTextWidget;

  ///Widget to receive the iamge when displaying [BotStateImage]
  final Widget Function(Image image, List<MarkdownBody>? label)? botImageWidget;

  ///SizedBox hight between messages of the same user
  final double? sameUserSpacing;

  ///SizedBox hight betweewn messagen of different users
  final double? difUsersSpacing;

  //TODO add to metadata
  ///The bot avatar that appears bellow the messages
  final Image? botFace;

  ChatBotWidget({
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
    this.botFace,
  }) : super(key: key);

  final ItemScrollController _scrollController = ItemScrollController();

  List<BotStateBase> get history => chatBot.history;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => BotUserOpenTextController()),
        ),
      ],
      child: Builder(builder: (context) {
        BotUserOpenTextController openTextController = context.read();

        return StreamBuilder(
          stream: chatBot.stateStream,
          builder: (context, AsyncSnapshot snapshot) {
            bool conection = snapshot.connectionState == ConnectionState.active;
            if (conection && snapshot.hasData) {
              if (chatBot.historyMode == false) {
                history.add(snapshot.data!);
              }

              _scrollToLast();

              if (history.last.runtimeType == BotStateOpenText) {
                WidgetsBinding.instance!.addPostFrameCallback((context) async {
                  openTextController.activate();
                });
              }

              //display the messages
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ScrollablePositionedList.separated(
                        shrinkWrap: true,
                        itemScrollController: _scrollController,
                        itemCount: history.length,
                        itemBuilder: _itemBuilder,
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                          height: difUsersSpacing,
                        ),
                      ),
                    ),
                    userOpenTextWidget ??
                        //default widget
                        BotUserOpenText(chatBot: chatBot),
                  ],
                ),
              );
            }

            return Container();
          },
        );
      }),
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

  Column _itemBuilder(
    context,
    index,
  ) {
    dynamic currentState = history[index];
    Type currentType = currentState.runtimeType;
    List<Widget> widgets = [];
    print("NEW STATE ${currentState.toString()}");

    //Show states bot message
    if (currentType != BotStateImage) {
      List<Widget> messagesColum = [];

      List<MarkdownBody> messages = currentState.messages();
      //add messages to the widgets list
      for (MarkdownBody message in messages) {
        messagesColum.add(
          botMessageWidget != null
              ? botMessageWidget!(message)
              //default widget
              : BotMessageWidget(message: message),
        );

        messagesColum.add(SizedBox(height: sameUserSpacing));
      }

      if (botFace != null) {
        widgets.add(
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: messagesColum,
                ),
              ),
              history.length - 1 == index
                  ? SizedBox(
                      height: 30,
                      child: botFace!,
                    )
                  : Container(),
            ],
          ),
        );
      } else {
        widgets.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: messagesColum,
          ),
        );
      }
    }

    //handle diffent types of states
    if (currentType == BotStateOpenText) {
      BotStateOpenText currentOpenText = currentState as BotStateOpenText;
      if (currentOpenText.userText == null) {
        print("currentState.userText veio null");
        widgets.add(
          //TODO
          // userMessageWidget != null
          //     ? userMessageWidget!(MarkdownBody(data: openTextState.userText!))
          //     //default widget
          //     :
          UserOpenMessageWidget(
            currenteState: currentOpenText,
          ),
        );
      } else {
        print("currentState.userText NAO null ${currentState.userText}");
        widgets.add(
          userMessageWidget != null
              ? userMessageWidget!(
                  MarkdownBody(data: currentOpenText.userText!))
              //default widget
              : UserMessageWidget(
                  message: currentOpenText.userText!,
                ),
        );
      }
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
    bool enabled = currentState.optionsSelectedByUser!.isEmpty;

    if (enabled) {
      widgets.add(
        BotMultipleChoiceFormWidget(
          chatBot: chatBot,
          botState: currentState,
          multipleCheckboxFormField: multipleCheckboxFormField,
          validator: currentState.validator,
        ),
      );
    } else {
      //add selected options messages as the user's answer
      for (int index in currentState.optionsSelectedByUser!) {
        BotOption currentOption = currentState.options()[index];

        widgets.add(
          userMessageWidget != null
              ? userMessageWidget!(currentOption.message)
              //default widget
              : UserMessageWidget(message: currentOption.message.data),
        );

        widgets.add(SizedBox(height: sameUserSpacing));
      }
    }
    return widgets;
  }

  List<Widget> _processImage(BotStateImage currentState) {
    List<Widget> widgets = [];

    Widget child;
    if (botImageWidget != null) {
      child = botImageWidget!(
        currentState.image(),
        currentState.label != null ? currentState.label!() : null,
      );
    } else {
      child = BotImageWidget(
        image: currentState.image(),
        label: currentState.label != null ? currentState.label!() : null,
      );
    }

    if (botFace != null) {
      widgets.add(
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: child,
            ),
            currentState == history.last
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                        child: botFace!,
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      );
    } else {
      widgets.add(child);
    }

    widgets.add(SizedBox(height: sameUserSpacing));

    return widgets;
  }

  List<Widget> _processSingleChoice(BotStateSingleChoice currentState) {
    List<Widget> widgets = [];
    if (currentState.options != null) {
      bool enabled = currentState.optionSelectedByUser.isNegative;

      //if enabled show options for user to select, else show user's answer
      if (enabled) {
        List<BotOption> options = currentState.options!();
        //process & add each bot transition
        for (var i = 0; i < options.length; i++) {
          BotOption option = options[i];

          MarkdownBody message = option.message;

          Widget child;
          if (botSingleChoiceWidget != null) {
            child = botSingleChoiceWidget!(message);
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
                    onTap: () async {
                      if (option.onChange != null) {
                        option.onChange!(option);
                      }
                      //save the answer
                      currentState.optionSelectedByUser = i;
                      //run the transition
                      if (currentState.decideTransition != null) {
                        String state = currentState.decideTransition!(option);
                        await chatBot.transitionTo(state);
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
            widgets.add(SizedBox(height: sameUserSpacing));
          }
        }
      } else {
        //add transition messages a the user's answer
        int index = currentState.optionSelectedByUser;
        MarkdownBody message = currentState.options!()[index].message;
        widgets.add(
          userMessageWidget != null
              ? userMessageWidget!(message)
              //default widget
              : UserMessageWidget(message: message.data),
        );
        widgets.add(SizedBox(height: difUsersSpacing));
      }
    }
    return widgets;
  }
}
