import 'package:flutter/material.dart';

class BotMessageWidget extends StatelessWidget {
  final Text message;
  final BoxDecoration? boxDecoration;

  const BotMessageWidget({
    Key? key,
    required this.message,
    this.boxDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: boxDecoration ??
                BoxDecoration(
                    color: Colors.purple[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
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
        Flexible(child: Container())
      ],
    );
  }
}
