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
  CheckboxListTile? checkboxListTile;
  // TODO Widget? button;
  void Function(int)? onChangeSelected;
  bool Function(List<int>)? onFinalize;
  int? intialValue;
  void Function(List<int>)? onChangeAll;
  List<int>? intialValues;
  bool disabled;

  MultipleCheckboxFormField({
    Key? key,
    required this.options,
    this.checkboxListTile,
    //this.button,
    required this.onChangeAll,
    this.onFinalize,
    this.intialValues,
    this.disabled = false,
  }) : super(key: key);

  @override
  _MultipleCheckboxFormFieldState createState() =>
      _MultipleCheckboxFormFieldState();
}

class _MultipleCheckboxFormFieldState extends State<MultipleCheckboxFormField> {
  List<int> selection = [];

  void updateSelected(int index, bool isMarked) {
    if (isMarked && !selection.contains(index)) {
      selection.add(index);
    } else if (!isMarked && selection.contains(index)) {
      selection.remove(index);
    }
    widget.onChangeAll!(selection);
  }

  bool valueSelection(int index) {
    return selection.contains(index);
  }

  @override
  void initState() {
    if (widget.intialValues != null) {
      selection = widget.intialValues ?? [];
    }

    super.initState();
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
                        onPressed: widget.disabled
                            ? null
                            : () {
                                bool isValid = widget.onFinalize!(selection);
                                if (isValid) {
                                  setState(() {
                                    widget.disabled = true;
                                  });
                                }
                              },
                        child: const Text("Ok"),
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
