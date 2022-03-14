import 'package:flutter/material.dart';

class BotSingleChoiceWidget extends StatelessWidget {
  final Text message;
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(child: Container()),
        Flexible(
          child: InkWell(
            onTap: () => onPress(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: boxDecoration ??
                  BoxDecoration(
                    color: Color.fromARGB(255, 222, 235, 255),
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
                children: [Flexible(child: message)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
