import 'package:flutter/material.dart';

import 'package:flutter_chat_composer/flutter_chat_composer.dart';

import 'check_box_widget.dart';

class BotMultipleChoiceFormWidget extends StatefulWidget {
  final ChatBot chatBot;
  final BotStateMultipleChoice botState;
  final MultipleCheckboxFormField? multipleCheckboxFormField;
  final String? Function(List<BotOption>)? validator;

  const BotMultipleChoiceFormWidget({
    Key? key,
    this.multipleCheckboxFormField,
    required this.chatBot,
    required this.botState,
    this.validator,
  }) : super(key: key);

  @override
  State<BotMultipleChoiceFormWidget> createState() =>
      _BotMultipleChoiceFormWidgetState();
}

class _BotMultipleChoiceFormWidgetState
    extends State<BotMultipleChoiceFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: widget.multipleCheckboxFormField ??
          //default widget
          MultipleCheckboxFormField(
            formKey: _formKey,
            chatBot: widget.chatBot,
            botState: widget.botState,
            validator: widget.validator,
          ),
    );
  }
}
