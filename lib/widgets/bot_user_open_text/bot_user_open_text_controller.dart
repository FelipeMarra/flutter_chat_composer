import 'package:flutter/material.dart';

class BotUserOpenTextController extends ChangeNotifier {
  final List<TextEditingController> _textEditingControllers = [];

  ///Wether if the open text widget is active or not
  bool _isActive = false;
  bool get isActive => _isActive;

  TextEditingController get currentController => _textEditingControllers.last;

  TextEditingController getEditingController() {
    print("NEW CONTROLLER");
    TextEditingController newController = TextEditingController();
    _textEditingControllers.add(newController);
    return newController;
  }

  void removeEditingController(TextEditingController controller) {
    _textEditingControllers.removeWhere((element) => element == controller);
  }

  void activate() {
    print("ACTIVATE");
    _isActive = true;
    notifyListeners();
  }

  void deactivate() {
    _isActive = false;
    notifyListeners();
  }
}
