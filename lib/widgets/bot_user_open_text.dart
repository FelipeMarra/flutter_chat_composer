import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

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
  final Widget Function(Text) userMessageWidget;

  const BotUserOpenText({
    Key? key,
    required this.chatBot,
    this.textField,
    this.icon,
    this.onPressed,
    required this.userMessageWidget,
  }) : super(key: key);

  @override
  State<BotUserOpenText> createState() => _BotUserOpenText();
}

class _BotUserOpenText extends State<BotUserOpenText> {
  late BotStateOpenText currentState;
  late bool wasPressed;
  late TextEditingController controller;

  @override
  void initState() {
    currentState = widget.chatBot.currentState as BotStateOpenText;

    wasPressed = currentState.userText.isNotEmpty;

    controller = TextEditingController(
      text: currentState.userText,
    );
    controller.addListener(() => currentState.userText = controller.text);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (wasPressed) {
      child = widget.userMessageWidget(
        Text.rich(TextSpan(text: controller.text)),
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
                              controller: controller,
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
                      currentState.decideTransition(controller),
                    );
                  },
                  icon: widget.icon ?? const Icon(Icons.send),
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
