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
      child = Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 70,
        child: Row(
          children: [
            Expanded(
              child: widget.textField ??
                  TextField(
                    controller: stateController.editingController!,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Insira sua resposta",
                    ),
                  ),
            ),
            IconButton(
              icon: widget.icon ?? const Icon(Icons.send),
              iconSize: 25,
              onPressed: () async {
                //run user's on pressed function
                if (widget.onPressed != null) {
                  widget.onPressed!();
                }
                //transition the machine
                await widget.chatBot.transitionTo(
                  stateController.currentState!
                      .decideTransition(stateController.editingController!),
                );
                //change to the user text widget
                stateController.deactivate();
              },
            ),
          ],
        ),
      );
    } else {
      child = Container();
    }

    return child;
  }
}
