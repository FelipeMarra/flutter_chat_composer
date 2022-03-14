import 'package:flutter/material.dart';

import 'package:flutter_chat_composer/flutter_chat_composer.dart';

import 'check_box_widget.dart';

class BotMultipleChoiceFormWidget extends StatefulWidget {
  final ChatBot chatBot;
  final MultipleCheckboxFormField? multipleCheckboxFormField;

  const BotMultipleChoiceFormWidget({
    Key? key,
    this.multipleCheckboxFormField,
    required this.chatBot,
  }) : super(key: key);

  @override
  State<BotMultipleChoiceFormWidget> createState() =>
      _BotMultipleChoiceFormWidgetState();
}

class _BotMultipleChoiceFormWidgetState
    extends State<BotMultipleChoiceFormWidget> {
  late BotStateMultipleChoice currentState;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    currentState = widget.chatBot.currentState as BotStateMultipleChoice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: widget.multipleCheckboxFormField ??
          //default widget
          MultipleCheckboxFormField(
            formKey: _formKey,
            chatBot: widget.chatBot,
          ),
    );
  }
}
