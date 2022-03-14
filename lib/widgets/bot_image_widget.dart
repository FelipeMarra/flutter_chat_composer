import 'package:flutter/material.dart';

class BotImageWidget extends StatelessWidget {
  final List<Text> label;
  final Image image;
  final BoxDecoration? boxDecoration;

  const BotImageWidget({
    Key? key,
    required this.label,
    required this.image,
    this.boxDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: boxDecoration ??
                BoxDecoration(
                    color: Colors.purple[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                image,
                Column(
                  children: label,
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(),
        )
      ],
    );
  }
}
