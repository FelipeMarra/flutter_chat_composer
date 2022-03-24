import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    Key? key,
    required BotOption option,
    FormFieldSetter<bool>? onSaved,
    required FormFieldValidator<bool> validator,
    required Function(bool)? onChange,
    CheckboxListTile? checkboxListTile,
    bool? value,
    bool initialValue = false,
    bool autovalidate = false,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            return checkboxListTile ??
                CheckboxListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  title: option.message,
                  value: value ?? state.value,
                  onChanged: onChange == null
                      ? null
                      : (value) => onChange(value ?? false),
                  subtitle: state.hasError
                      ? Builder(
                          builder: (BuildContext context) => Text(
                            state.errorText ?? "",
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ),
                        )
                      : null,
                  controlAffinity: ListTileControlAffinity.leading,
                );
          },
        );
}

///A checkbox widget to receive the input when the state is a BotStateMultipleChoice
class MultipleCheckboxFormField extends StatefulWidget {
  ///The key of the form used to validade de chackbox
  final GlobalKey<FormState> formKey;

  ///The chatbot beeing used
  final ChatBot chatBot;

  ///The state that built this widget
  final BotStateMultipleChoice botState;

  ///A personalized list tile
  final CheckboxListTile? checkboxListTile;

  ///A personalized validador for the for the checkboxListTile
  final String? Function(List<BotOption> options)? validator;

  ///A personalized widget for the text button
  final Widget? buttonChild;

  ///Callback for when the selected options changed
  final void Function(List<int>)? onChangeAll;

  ///Callback for when the button is clicked
  final bool Function(List<int>)? onFinalize;

  ///Inial values indexes
  final List<int>? intialValues;

  const MultipleCheckboxFormField({
    Key? key,
    required this.formKey,
    required this.chatBot,
    required this.botState,
    this.checkboxListTile,
    this.validator,
    this.buttonChild,
    this.onChangeAll,
    this.onFinalize,
    this.intialValues,
  }) : super(key: key);

  @override
  _MultipleCheckboxFormFieldState createState() =>
      _MultipleCheckboxFormFieldState();
}

class _MultipleCheckboxFormFieldState extends State<MultipleCheckboxFormField> {
  bool disabled = false;
  //options that come from the state to generate the widget
  late List<BotOption> options;
  List<int> selection = [];
  //options that are currently selected
  List<BotOption> get optionsSelection {
    List<BotOption> optionSelection = [];

    for (int index in selection) {
      optionSelection.add(widget.botState.options()[index]);
    }

    return optionSelection;
  }

  @override
  void initState() {
    options = widget.botState.options();

    if (widget.intialValues != null) {
      selection = widget.intialValues ?? [];
    }
    super.initState();
  }

  void updateSelected(int index, bool isMarked) {
    if (isMarked && !selection.contains(index)) {
      selection.add(index);
    } else if (!isMarked && selection.contains(index)) {
      selection.remove(index);
    }

    if (widget.onChangeAll != null) {
      widget.onChangeAll!(selection);
    }

    //Call the options onChanege callbacks
    for (int index in selection) {
      BotOption currentOption = widget.botState.options()[index];
      if (currentOption.onChange != null) {
        currentOption.onChange!(currentOption);
      }
    }
  }

  bool valueSelection(int index) {
    return selection.contains(index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(child: Container()),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 222, 235, 255),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                )
              ],
            ),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    BotOption option = options[index];

                    return CheckboxFormField(
                      checkboxListTile: widget.checkboxListTile,
                      option: option,
                      value: valueSelection(index),
                      onChange: disabled
                          ? null
                          : (value) {
                              setState(() {
                                updateSelected(index, value);
                              });
                            },
                      validator: (value) {
                        if (widget.validator != null) {
                          return widget.validator!(optionsSelection);
                        }

                        //Default validator
                        if (selection.isEmpty) {
                          return "Selecione uma opção";
                        }

                        return null;
                      },
                    );
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: disabled
                            ? null
                            : () {
                                //validation
                                if (widget.formKey.currentState!.validate()) {
                                  for (int index in selection) {
                                    widget.botState.optionsSelectedByUser!
                                        .add(index);
                                    widget.botState.optionsSelectedByUser!
                                        .sort();
                                  }

                                  String nextState =
                                      widget.botState.decideTransition(
                                    optionsSelection,
                                  );
                                  widget.chatBot.transitionTo(nextState);
                                  setState(() {
                                    disabled = true;
                                  });

                                  if (widget.onFinalize != null) {
                                    widget.onFinalize!(selection);
                                  }
                                }
                              },
                        child: widget.buttonChild ?? const Text("Ok"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
