import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_composer/flutter_chat_composer.dart';

class MyChatBot2 {
  static const String botName = "Juliette";
  static String userName = "";
  static String smartPhoneModel = "IPhone 13";

  ChatBot chatBot() {
    return ChatBot(
      id: "chat_bot",
      initialStateId: "A",
      states: [
        _stateA(),
        _stateALoop(),
        _stateB(),
        _stateC(),
        _stateD(),
        _stateE(),
        _stateF(),
        _stateG(),
        _stateH(),
        _stateI(),
        _stateJ(),
        _stateK(),
      ],
    );
  }

  String _stateADecision(TextEditingController textController) {
    if (textController.text.isEmpty) {
      return "ALoop";
    } else {
      userName = textController.text;
      return "B";
    }
  }

  BotStateOpenText _stateA() {
    return BotStateOpenText(
      id: "A",
      messages: () => [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: "Oi, eu sou a "),
              TextSpan(
                text: botName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        RichText(
          text: const TextSpan(children: [
            TextSpan(text: "Eu posso te ajudar com a escolha do "),
            TextSpan(
              text: "seu próximo smartphone",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ", mas antes preciso saber alguns detalhes...")
          ]),
        ),
        RichText(text: const TextSpan(text: "Me conta, qual seu nome?")),
      ],
      transitions: [
        BotTransition(id: "A=>ALoop", to: "ALoop"),
        BotTransition(id: "A=>B", to: "B"),
      ],
      decideTransition: _stateADecision,
    );
  }

  BotStateOpenText _stateALoop() {
    return BotStateOpenText(
      id: "ALoop",
      messages: () => [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: "Eu realmente preciso saber seu nome... "),
            ],
          ),
        ),
      ],
      transitions: [
        BotTransition(id: "ALoop=>ALoop", to: "ALoop"),
        BotTransition(id: "ALoop=>B", to: "B"),
      ],
      decideTransition: (textController) {
        if (textController.text.isEmpty) {
          return "ALoop";
        } else {
          userName = textController.text;
          return "B";
        }
      },
    );
  }

  BotStateMultipleChoice _stateB() {
    return BotStateMultipleChoice(
      id: "B",
      messages: () => [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text:
                      "Legal $userName! Agora que sei um pouco sobre você podemos começar. Vamos la?"),
            ],
          ),
        ),
        RichText(
          text: const TextSpan(children: [
            TextSpan(text: "Qual das categorias de apps a seguir você faz "),
            TextSpan(
              text: "maior ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: "uso?"),
          ]),
        ),
      ],
      options: [
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Jogos"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Redes Sociais"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Edição"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Produtividade"),
          ),
        ),
      ],
      transitions: [
        BotTransition(
          id: "B=>C",
          to: "C",
        ),
      ],
      decideTransition: (selection) => "C",
    );
  }

  BotStateMultipleChoice _stateC() {
    return BotStateMultipleChoice(
      id: "C",
      messages: () => [
        RichText(
          text: const TextSpan(children: [
            TextSpan(text: "Qual das categorias de apps a seguir você faz "),
            TextSpan(
              text: "menor ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: "uso?"),
          ]),
        ),
      ],
      options: [
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Jogos"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Redes Sociais"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Edição"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Produtividade"),
          ),
        ),
      ],
      transitions: [
        BotTransition(
          id: "C=>D",
          to: "D",
        ),
      ],
      decideTransition: (selection) => "D",
    );
  }

  BotStateMultipleChoice _stateD() {
    return BotStateMultipleChoice(
        id: "D",
        messages: () => [
              RichText(
                text: const TextSpan(children: [
                  TextSpan(
                      text:
                          "Legal, agora quero saber um pouco mais sobre seu uso no geral. "),
                  TextSpan(
                      text:
                          "Em relação aos apps abaixo, quais você mais utiliza?"),
                ]),
              ),
            ],
        options: [
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Minecraft"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Free Fire"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Call of Duty"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Fortinite"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Geshin Impact"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "League of Legends Wild Rift"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Asphalt 9"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Candy Crush"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "PES 2021"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Minecraft"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Outros jogos"),
            ),
          ),
          BotOption(
            message: RichText(
              text: const TextSpan(text: "Nenhuma das opções acima"),
            ),
          ),
        ],
        transitions: [
          BotTransition(
            id: "D=>E",
            to: "E",
          ),
        ],
        decideTransition: (selection) => "E");
  }

  BotStateMultipleChoice _stateE() {
    return BotStateMultipleChoice(
      id: "E",
      messages: () => [
        RichText(
          text: const TextSpan(children: [
            TextSpan(
                text:
                    "Agora, sobre redes sociais, quais dos apps abaixo você faz uso mais frequente? "),
          ]),
        ),
      ],
      options: [
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Instagram"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Facebook"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Whatsapp"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Tik Tok"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Youtube"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Snapchat"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Twitter"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Outras Redes Sociais"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Nenhuma das opções acima"),
          ),
        ),
      ],
      transitions: [
        BotTransition(
          id: "E=>F",
          to: "F",
        ),
      ],
      decideTransition: (selection) => "F",
    );
  }

  BotStateMultipleChoice _stateF() {
    return BotStateMultipleChoice(
      id: "F",
      messages: () => [
        RichText(
          text: const TextSpan(children: [
            TextSpan(text: "Entendi, interessante"),
          ]),
        ),
        RichText(
          text: const TextSpan(children: [
            TextSpan(
                text:
                    "Para fazer edição pelo smartphone, você faz uso de quais dos apps abaixo?"),
          ]),
        ),
      ],
      options: [
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Tik Tok"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Photoshop"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Canva"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Vimeo"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Inshot"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Capcut"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Outros app de edição"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Nenhuma das opções acima"),
          ),
        ),
      ],
      transitions: [
        BotTransition(
          id: "F=>G",
          to: "G",
        ),
      ],
      decideTransition: (selection) => "G",
    );
  }

  BotStateMultipleChoice _stateG() {
    return BotStateMultipleChoice(
      id: "G",
      messages: () => [
        RichText(
          text: const TextSpan(children: [
            TextSpan(
                text:
                    "Lega, agora só mais uma pergunta antes deu te sugerir um modelo."),
          ]),
        ),
        RichText(
          text: const TextSpan(children: [
            TextSpan(
                text:
                    "Em relação a produtividade, quais dos apps abaixo você utiliza mais?"),
          ]),
        ),
      ],
      options: [
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Adobe Scam"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "CamScanner"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "PowerPoint"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Vimeo"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Google Docs"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Google Maps"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Outros app de produtividade"),
          ),
        ),
        BotOption(
          message: RichText(
            text: const TextSpan(text: "Nenhuma das opções acima"),
          ),
        ),
      ],
      transitions: [
        BotTransition(
          id: "G=>H",
          to: "H",
        ),
      ],
      decideTransition: (selection) => "H",
    );
  }

  BotState _stateH() {
    return BotState(
      id: "H",
      messages: () => [
        RichText(
          text: const TextSpan(children: [
            TextSpan(
                text: "Prontinho, finalizamos as perguntas, agora é comigo!"),
          ]),
        ),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                  text:
                      "Com base nas suas respostas o smartphone que mais se adequa ao seu uso é "),
              TextSpan(
                text: smartPhoneModel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
      transitions: [
        BotTransition(id: "H=>I", to: "I"),
      ],
      onEnter: (machine) async {
        await Future.delayed(const Duration(seconds: 1));
        machine.transitionTo("I");
      },
    );
  }

  BotState _stateI() {
    return BotState(
      id: "I",
      messages: () => [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: "Adorei convensar com você!"),
            ],
          ),
        ),
        RichText(
          text: const TextSpan(children: [
            TextSpan(
                text:
                    "Mas me conta, eu consegui te ajudar com o que precisava?"),
          ]),
        ),
      ],
      transitions: [
        BotTransition(
          id: "I=>J",
          to: "J",
          message: RichText(text: const TextSpan(text: "Sim")),
        ),
        BotTransition(
          id: "I=>K",
          to: "K",
          message: RichText(text: const TextSpan(text: "Não")),
        ),
      ],
    );
  }

  BotState _stateJ() {
    return BotState(
      id: "J",
      messages: () => [
        RichText(
          text: const TextSpan(children: [
            TextSpan(text: "Que bom!"),
          ]),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(text: "Obrigado, e tenha um ótimo dia $userName!"),
          ]),
        ),
      ],
    );
  }

  BotState _stateK() {
    return BotState(
      id: "K",
      messages: () => [
        RichText(
          text: const TextSpan(children: [
            TextSpan(text: "Ahh que pena..."),
          ]),
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(text: "Obrigado, e tenha um ótimo dia $userName!"),
          ]),
        ),
      ],
    );
  }
}
