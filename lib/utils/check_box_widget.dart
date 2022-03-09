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

//TODO change to multiple choices only
class MultipleCheckboxFormField extends StatefulWidget {
  final List<BotOption> options;
  final bool disabled;

  CheckboxListTile? checkboxListTile;
  // TODO Widget? button;
  void Function(int)? onChangeSelected;
  void Function(List<int>) onFinalize;
  int? intialValue;
  void Function(List<int>)? onChangeAll;
  List<int>? intialValues;
  bool multipleChoices = false;

  MultipleCheckboxFormField({
    Key? key,
    required this.options,
    this.disabled = false,
    this.checkboxListTile,
    //this.button,
    required this.onChangeAll,
    required this.onFinalize,
    this.intialValues,
  }) : super(key: key) {
    multipleChoices = true;
  }

  @override
  _MultipleCheckboxFormFieldState createState() =>
      _MultipleCheckboxFormFieldState();
}

class _MultipleCheckboxFormFieldState extends State<MultipleCheckboxFormField> {
  int selected = -1;
  List<int> selection = [];

  void updateSelected(int index, bool isMarked) {
    if (widget.multipleChoices) {
      if (isMarked && !selection.contains(index)) {
        selection.add(index);
      } else if (!isMarked && selection.contains(index)) {
        selection.remove(index);
      }
      widget.onChangeAll!(selection);
    } else {
      selected = index;
      if (isMarked) widget.onChangeSelected!(selected);
    }
  }

  bool valueSelection(int index) {
    if (widget.multipleChoices) {
      return selection.contains(index);
    } else {
      return selected == index ? true : false;
    }
  }

  @override
  void initState() {
    if (widget.multipleChoices) {
      if (widget.intialValues != null) {
        selection = widget.intialValues ?? [];
      }
    } else {
      if (widget.intialValue != null && selected == -1) {
        selected = widget.intialValue ?? -1;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  BotOption option = widget.options[index];

                  return CheckboxFormField(
                      checkboxListTile: widget.checkboxListTile,
                      option: option,
                      value: valueSelection(index),
                      onChange: widget.disabled
                          ? null
                          : (value) {
                              setState(() {
                                updateSelected(index, value);
                              });
                            },
                      validator: (value) {
                        if (widget.multipleChoices) {
                          if (selection.isEmpty) {
                            return "Selecione uma opção";
                          }
                        } else {
                          if (selected == -1) {
                            return "Selecione uma opção";
                          }
                        }

                        return null;
                      });
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        widget.onFinalize(selection);
                      },
                      child: const Text("Ok"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Flexible(child: Container()),
      ],
    );
  }
}
