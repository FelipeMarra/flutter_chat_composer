# Flutter Chat Composer

>How about transforming your state machine in a chat bot? flutter chat composer makes use of state machines generated by <a href="https://github.com/FelipeMarra/state-composer">state_composer<a> to create chatbots based on those states

# Usage

## Creating the chat's state machine

A chat bot is composed of states

``` dart 
ChatBot(
    id: "myChatBot",
    initialStateId: "A",
    states: [
    _stateA(),
    _stateB(),
    _stateC(),
    _stateD(),
    _stateE(),
    ],
);
```
### State Properties
Will have the id and onEnter/onLeave functions, like in  <a href="https://github.com/FelipeMarra/state-composer">state_composer<a>. But also
a list of messages that will be displayed on enter the state. Each message is a list of texts allowing better personalization.
    
### State Types
Each state can be of open or closed text.<br>
A closed text one will take transitions with predefined messages to be displayed and when the option is selected user's [ChatBotWidget.userMessageWidget] will
be displayed. <br>
A open text one have a function that comes with the text field's controller that will be used to decide the next state <br>

### Open Text Example
``` dart 
  BotState _stateA() {
    return BotStateOpenText(
      id: "A",
      messages: [
        Message(
          texts: [
            const Text("Wellcome to "),
            const Text(
              "State A.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Message(
          texts: [
            const Text("Tell me, what do you think about this state?"),
          ],
        ),
      ],
      transitions: [
        BotTransition(
          id: "A=>B",
          to: "B",
        ),
        BotTransition(
          id: "A=>C",
          to: "C",
        ),
      ],
      decideTransition: (textController) {
        if (textController.text.isNotEmpty) {
          return "B";
        } else {
          return "C";
        }
      },
      onEnter: (machine) {
        print("Entered ${machine.currentState!.id}");
      },
      onLeave: (machine, nextState) {
        print("Left ${machine.currentState!.id} going to ${nextState.id}");
      },
    );
  }
```
### Closed Text Example
``` dart 
  BotState _stateB() {
    return BotState(
      id: "B",
      messages: [
        Message(
          texts: [
            const Text("Ok, so now you're in "),
            const Text(
              "State B!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Message(texts: [const Text("Where do you wanna go next?")])
      ],
      transitions: [
        BotTransition(
          id: "B=>D",
          to: "D",
          message: Message(texts: [
            const Text("Go from B to D"),
          ]),
        ),
        BotTransition(
          id: "B=>E",
          to: "E",
          message: Message(
            texts: [
              const Text("Go from B to E"),
            ],
          ),
        ),
      ],
      onEnter: (machine) {
        print("Entered ${machine.currentState!.id}");
      },
    );
  }
```

## Creating the UI

UI is created using the `ChatBotWidget`, just enter the widgets that will be used to display
each part of the state machine.

``` dart 
ChatBotWidget(
    ///Widget that displays the [Message]s of the bot, see each group of messages ass a paragraph
    botMessageWidget: _botMessageWidget,
    ///Widget that displays the [Message] of each transition option
    botTransitionWidget: _botTransitionWidget,
    ///Widget that displays the [Message] related to the transition choosen by the user
    userMessageWidget: _userMessageWidget,
    ///Widget that captures the text the user typed when the state type is [BotStateOpenText]
    userOpenTextWidget: _userOpenTextWidget,
    ///SizedBox hight between messages of the same user
    sameUserSpacing: 1,
    ///SizedBox hight betweewn messagen of different users
    difUsersSpacing: 10,
    ///The [ChatBot] that will generate the chat
    chatBot: _myChatBot,
),
```

For a better understandin see the <a href="https://github.com/FelipeMarra/flutter_chat_composer/tree/main/example">example<a>
