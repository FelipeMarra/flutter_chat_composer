import 'package:flutter/material.dart';

class BotSingleChoiceWidget extends StatelessWidget {
  final RichText message;
  final Function onPress;
  final BoxDecoration? boxDecoration;

  const BotSingleChoiceWidget({
    Key? key,
    required this.onPress,
    required this.message,
    this.boxDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: InkWell(
            onTap: () => onPress(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: boxDecoration ??
                  BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                        )
                      ]),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Flexible(child: message)],
              ),
            ),
          ),
        ),
        Flexible(child: Container())
      ],
    );
  }
}
