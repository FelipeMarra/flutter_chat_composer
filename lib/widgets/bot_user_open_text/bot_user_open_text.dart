import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';
import 'package:flutter_chat_composer/widgets/bot_user_open_text/bot_user_open_text_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

class BotUserOpenText extends StatefulWidget {
  ///The chatBot beeing used
  final ChatBot chatBot;

  ///Personalized textField
  final TextField? textField;

  ///Icon shown in text fileds right
  final Icon? icon;

  ///When the icon button is pressed
  final Function? onPressed;

  ///User message widget to be shown when the button is pressed
  final Widget Function(MarkdownBody message) userMessageWidget;

  const BotUserOpenText({
    Key? key,
    required this.chatBot,
    this.textField,
    this.icon,
    this.onPressed,
    required this.userMessageWidget,
  }) : super(key: key);

  @override
  State<BotUserOpenText> createState() => _BotUserOpenTextState();
}

class _BotUserOpenTextState extends State<BotUserOpenText> {
  @override
  Widget build(BuildContext context) {
    BotUserOpenTextController stateController = context.watch();
    Widget child;

    if (stateController.isActive) {
      child = Row(
        children: [
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: widget.textField ??
                            TextField(
                              controller: stateController.editingController!,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    //run user's on pressed function
                    if (widget.onPressed != null) {
                      widget.onPressed!();
                    }
                    //transition the machine
                    widget.chatBot.transitionTo(
                      stateController.currentState!
                          .decideTransition(stateController.editingController!),
                    );
                    //change to the user text widget
                    stateController.deactivate();
                  },
                  icon: widget.icon ?? const Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      );
    } else {
      child = Container();
    }

    return child;
  }
}
