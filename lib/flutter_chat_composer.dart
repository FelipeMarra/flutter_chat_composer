library flutter_chat_composer;

import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/models/chat_bot_models.dart';
import 'package:flutter_chat_composer/widgets/bot_user_open_text.dart';

export 'models/chat_bot_models.dart';

class ChatBotWidget extends StatefulWidget {
  ///The [ChatBot] that will generate the chat
  final ChatBot chatBot;

  ///Widget that displays the [Message]s of the bot, see each group of messages
  ///ass a paragraph
  final Widget Function(RichText) botMessageWidget;

  ///Widget that displays the [Message] of each transition option
  final Widget Function(RichText) botTransitionWidget;

  ///Widget that displays the [Message] related to the transition choosen by the user
  final Widget Function(RichText) userMessageWidget;

  ///Widget that captures the text the user typed when the state type is [BotStateOpenText]
  BotUserOpenText? userOpenTextWidget;

  ///SizedBox hight between messages of the same user
  final double? sameUserSpacing;

  ///SizedBox hight betweewn messagen of different users
  final double? difUsersSpacing;

  ChatBotWidget({
    Key? key,
    required this.chatBot,
    required this.botMessageWidget,
    required this.botTransitionWidget,
    required this.userMessageWidget,
    this.sameUserSpacing,
    this.difUsersSpacing,
    this.userOpenTextWidget,
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
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: chatWidgets.length,
                  itemBuilder: (context, index) {
                    return chatWidgets[index];
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _processSnapshot(AsyncSnapshot<BotState> snapshot) async {
    BotState currentState = snapshot.data!;
    //get message and options data
    //add them to the messages' list
    List<RichText> messages = currentState.messages;
    for (RichText message in messages) {
      chatWidgets.add(widget.botMessageWidget(message));

      chatWidgets.add(SizedBox(height: widget.sameUserSpacing));
    }

    //test the text type we're dealing with
    if (currentState.runtimeType == BotStateOpenText) {
      _processOpenText(currentState as BotStateOpenText);
    } else {
      _processClosedText(currentState);
    }

    chatWidgets.add(SizedBox(height: widget.difUsersSpacing));
  }

  _processOpenText(BotStateOpenText currentState) {
    //add open user's text widget

    chatWidgets.add(
      IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: widget.userOpenTextWidget!,
            ),
          ],
        ),
      ),
    );
  }

  _processClosedText(currentState) {
    List<BotTransition> transitions = currentState.transitions;
    //process & add each bot transition
    for (var i = 0; i < transitions.length; i++) {
      BotTransition transition = transitions[i];

      chatWidgets.add(
        InkWell(
          child: widget.botTransitionWidget(transition.message!),
          onTap: () {
            //add transition messages a the user's answer
            chatWidgets.add(widget.userMessageWidget(transition.message!));
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
