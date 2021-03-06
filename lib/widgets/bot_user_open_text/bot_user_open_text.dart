import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';
import 'package:flutter_chat_composer/widgets/bot_user_open_text/bot_user_open_text_controller.dart';
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

  const BotUserOpenText({
    Key? key,
    required this.chatBot,
    this.textField,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  State<BotUserOpenText> createState() => _BotUserOpenTextState();
}

class _BotUserOpenTextState extends State<BotUserOpenText> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BotStateOpenText get currentState =>
      widget.chatBot.currentState! as BotStateOpenText;

  @override
  Widget build(BuildContext context) {
    BotUserOpenTextController openTextController = context.watch();
    Widget child;

    if (openTextController.isActive) {
      child = Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Row(
          children: [
            Form(
              key: _formKey,
              child: Expanded(
                child: widget.textField ??
                    TextFormField(
                      validator: (value) => currentState.validator != null
                          ? currentState.validator!(value ?? "")
                          : null,
                      controller: openTextController.currentController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Insira sua resposta",
                      ),
                    ),
              ),
            ),
            IconButton(
              icon: widget.icon ?? const Icon(Icons.send),
              iconSize: 25,
              splashRadius: 1,
              onPressed: () async {
                if (_formKey.currentState!.validate() == false) {
                  return;
                }

                //run user's on pressed function
                if (widget.onPressed != null) {
                  await widget.onPressed!();
                }

                //transition the machine
                openTextController.deactivate();

                currentState.userText = currentState.userText ?? "";

                await widget.chatBot.transitionTo(
                  currentState.decideTransition(currentState.userText!),
                );
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
