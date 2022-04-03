import 'package:flutter/material.dart';
import '../bot_user_open_text/bot_user_open_text_controller.dart';

class UserOpenMessageWidget extends StatefulWidget {
  final String? message;
  final BoxDecoration? boxDecoration;
  final BotUserOpenTextController openTextController;

  const UserOpenMessageWidget({
    Key? key,
    this.message,
    required this.openTextController,
    this.boxDecoration,
  }) : super(key: key);

  @override
  State<UserOpenMessageWidget> createState() => _UserOpenMessageWidgetState();
}

class _UserOpenMessageWidgetState extends State<UserOpenMessageWidget> {
  TextEditingController? editingController;
  String message = "";

  @override
  void initState() {
    if (widget.message == null) {
      editingController = TextEditingController();
      widget.openTextController.editingController = editingController;
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        editingController!.addListener(() {
          setState(() {
            message = editingController!.text;
            widget.openTextController.currentState!.userText =
                editingController!.text;
          });
        });
      });
    } else {
      message = widget.message!;
    }
    super.initState();
  }

  @override
  void dispose() {
    if (editingController != null) {
      editingController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
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
          child: Text(message),
        ),
      ],
    );
  }
}
