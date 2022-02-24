library flutter_chat_composer;

import 'package:flutter/material.dart';
import 'package:flutter_chat_composer/models/chat_bot_models.dart';

export 'models/chat_bot_models.dart' show ChatBot, BotState, BotTransition;

class ChatBotWidget extends StatefulWidget {
  final ChatBot chatBot;
  final Widget Function(List<Message>) botMessageWidget;
  final Widget Function(Message) botOptionWidget;
  final Widget Function(Message) userMessageWidget;

  const ChatBotWidget({
    Key? key,
    required this.chatBot,
    required this.botMessageWidget,
    required this.botOptionWidget,
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
        //get message and options data
        List<Message> messages = snapshot.data!.messages;
        List<BotTransition> transitions = snapshot.data!.transitions;
        //add them to the messages' list
        chatWidgets.add(widget.botMessageWidget(messages));
        for (BotTransition transition in transitions) {
          chatWidgets.add(widget.botOptionWidget(transition.transitionMessage));
        }
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
}
