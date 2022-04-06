import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/models/chat_bot_models.dart';
import 'package:provider/provider.dart';
import 'bot_user_open_text_controller.dart';

class UserOpenMessageWidget extends StatefulWidget {
  final BoxDecoration? boxDecoration;
  final BotStateOpenText currenteState;

  const UserOpenMessageWidget({
    Key? key,
    this.boxDecoration,
    required this.currenteState,
  }) : super(key: key);

  @override
  State<UserOpenMessageWidget> createState() => _UserOpenMessageWidgetState();
}

class _UserOpenMessageWidgetState extends State<UserOpenMessageWidget> {
  late TextEditingController editingController;
  late BotUserOpenTextController controller;
  String message = "";

  @override
  void initState() {
    print("INIT STATE");
    controller = context.read();
    editingController = controller.getEditingController();
    editingController.addListener(() {
      setState(() {
        message = editingController.text;
        widget.currenteState.userText = editingController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    //editingController.removeListener(() {});
    //controller.removeEditingController(editingController);
    //editingController.dispose();
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
