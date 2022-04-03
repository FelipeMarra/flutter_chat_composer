import 'package:flutter/material.dart';

class UserMessageWidget extends StatelessWidget {
  final String message;
  final BoxDecoration? boxDecoration;

  const UserMessageWidget({Key? key, required this.message, this.boxDecoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: boxDecoration ??
              BoxDecoration(
                color: const Color.fromARGB(255, 159, 196, 255),
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
          child: Text(message),
        ),
      ],
    );
  }
}
