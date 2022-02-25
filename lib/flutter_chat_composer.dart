library flutter_chat_composer;

import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/models/chat_bot_models.dart';

export 'models/chat_bot_models.dart' show ChatBot, BotState, BotTransition;

class ChatBotWidget extends StatefulWidget {
  final ChatBot chatBot;
  final Widget Function(List<Message>) botMessageWidget;
  final Widget Function(Message) botTransitionWidget;
  final Widget Function(Message) userMessageWidget;

  const ChatBotWidget({
    Key? key,
    required this.chatBot,
    required this.botMessageWidget,
    required this.botTransitionWidget,
    required this.userMessageWidget,
  }) : super(key: key);

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

///1 - Ao entrar em um estado:
///Mostrar Mensagem Do Estado Atual
///Mostar Opções Clicáveis do Estado Atual
///
///2 - Ao clicar na opção Mudar para o próximo estado, repetir 2
///
class _ChatBotWidgetState extends State<ChatBotWidget> {
  List<Widget> chatWidgets = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.chatBot.stateStream,
      builder: (context, AsyncSnapshot<BotState> snapshot) {
        if (snapshot.data == null) {
          return Container();
        }

        _processSnapshot(snapshot);

        //display the messages
        return SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: chatWidgets.length,
            itemBuilder: (context, index) {
              return chatWidgets[index];
            },
          ),
        );
      },
    );
  }

  _processSnapshot(AsyncSnapshot<BotState> snapshot) {
    BotState currentState = snapshot.data!;
    //get message and options data
    //add them to the messages' list
    chatWidgets.add(widget.botMessageWidget(currentState.messages));
    //process & add each bot transition
    for (BotTransition transition in currentState.transitions) {
      chatWidgets.add(
        //TODO on mouse over change the widget
        InkWell(
          child: widget.botTransitionWidget(transition.message),
          onTap: () async {
            //add transition messages a the user's answer
            setState(() {
              chatWidgets.add(widget.userMessageWidget(transition.message));
            });
            //run the transition
            await widget.chatBot.transitionTo(transition.to);
          },
        ),
      );
    }
  }
}
