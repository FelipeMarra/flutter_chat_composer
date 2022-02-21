library flutter_chat_composer;

import 'package:state_composer/state_composer.dart';

class StateMachineChat extends StateMachine {
  StateMachineChat({
    required String id,
    required List<State> states,
    required String initialStateId,
  }) : super(
          id: id,
          states: states,
          initialStateId: initialStateId,
        );
}
