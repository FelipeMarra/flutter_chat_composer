import 'package:flutter/material.dart';

class BotSingleChoiceWidget extends StatelessWidget {
  final Text message;
  final BoxDecoration? boxDecoration;

  const BotSingleChoiceWidget(
    this.message, {
    Key? key,
    this.boxDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: boxDecoration ??
          BoxDecoration(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: message,
          ),
        ],
      ),
    );
  }
}
