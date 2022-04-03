import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/models/chat_bot_models.dart';

class BotUserOpenTextController extends ChangeNotifier {
  BotStateOpenText? currentState;
  TextEditingController? editingController;

  ///Wether if the open text widget is active or not
  bool get isActive => currentState != null && editingController != null;

  void activate(BotStateOpenText newState) {
    currentState = newState;
    notifyListeners();
  }

  void deactivate() {
    currentState = null;
    editingController = null;
    notifyListeners();
  }
}
