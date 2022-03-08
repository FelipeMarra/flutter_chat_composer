import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

class BotUserOpenText extends StatefulWidget {
  final Icon icon;
  final Function? onPressed;
  final TextField? textField;
  final TextEditingController controller;
  final Widget Function(RichText) userMessageWidget;
  final ChatBot chatBot;
  const BotUserOpenText({
    Key? key,
    required this.chatBot,
    required this.userMessageWidget,
    required this.controller,
    required this.icon,
    this.textField,
    this.onPressed,
  }) : super(key: key);

  @override
  State<BotUserOpenText> createState() => _BotUserOpenText();
}

class _BotUserOpenText extends State<BotUserOpenText> {
  bool wasPressed = false;

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (wasPressed) {
      child = widget.userMessageWidget(
        RichText(
          text: TextSpan(text: widget.controller.text),
        ),
      );
    } else {
      child = Row(
        children: [
          Flexible(child: Container()),
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: widget.textField ??
                            TextField(
                              controller: widget.controller,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    //change to the user text widget
                    setState(() {
                      wasPressed = true;
                    });
                    //run user's on pressed function
                    if (widget.onPressed != null) {
                      widget.onPressed!();
                    }
                    //transition the machine
                    BotStateOpenText currentState =
                        widget.chatBot.currentState! as BotStateOpenText;
                    widget.chatBot.transitionTo(
                      currentState.decideTransition(widget.controller),
                    );
                  },
                  icon: widget.icon,
                )
              ],
            ),
          ),
        ],
      );
    }

    return child;
  }
}
