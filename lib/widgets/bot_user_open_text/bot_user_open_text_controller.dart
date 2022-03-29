import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/models/chat_bot_models.dart';

class BotUserOpenTextController extends ChangeNotifier {
  BotStateOpenText? currentState;
  TextEditingController? editingController;

  ///Wether if the open text widget is active or not
  bool get isActive => currentState != null;

  void activate(BotStateOpenText newState) {
    currentState = newState;
    editingController = TextEditingController();
    //keep the text inside the state updadted
    editingController!.addListener(
      () => currentState!.userText = editingController!.text,
    );

    notifyListeners();
  }

  void deactivate() {
    currentState = null;
    //editingController!.dispose();
    notifyListeners();
  }
}
