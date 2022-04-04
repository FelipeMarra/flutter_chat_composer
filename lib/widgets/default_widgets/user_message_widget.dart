import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class UserMessageWidget extends StatefulWidget {
  final MarkdownBody? message;
  final BoxDecoration? boxDecoration;
  final TextEditingController controller;

  const UserMessageWidget({
    Key? key,
    this.message,
    required this.controller,
    this.boxDecoration,
  }) : super(key: key);

  @override
  State<UserMessageWidget> createState() => _UserMessageWidgetState();
}

class _UserMessageWidgetState extends State<UserMessageWidget> {
  String message = "";

  @override
  void initState() {
    if (widget.message == null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        widget.controller.addListener(() {
          message = widget.controller.text;
        });
      });
    } else {
      message = widget.message!.data;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(child: Container()),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: widget.boxDecoration ??
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [Flexible(child: Text(message))],
            ),
          ),
        ),
      ],
    );
  }
}
