import 'package:flutter/material.dart';
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
        _stateHImage(),
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
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "Oi, eu sou a "),
              TextSpan(
                text: botName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Text.rich(
          TextSpan(children: [
            TextSpan(text: "Eu posso te ajudar com a escolha do "),
            TextSpan(
              text: "seu próximo smartphone",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ", mas antes preciso saber alguns detalhes...")
          ]),
        ),
        const Text.rich(TextSpan(text: "Me conta, qual seu nome?")),
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
        const Text.rich(
          TextSpan(
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
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text:
                      "Legal $userName! Agora que sei um pouco sobre você podemos começar. Vamos la?"),
            ],
          ),
        ),
        const Text.rich(
          TextSpan(children: [
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
          message: const Text.rich(
            TextSpan(text: "Jogos"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Redes Sociais"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Edição"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Produtividade"),
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
        const Text.rich(
          TextSpan(children: [
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
          message: const Text.rich(
            TextSpan(text: "Jogos"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Redes Sociais"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Edição"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Produtividade"),
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
              const Text.rich(
                TextSpan(children: [
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
            message: const Text.rich(
              TextSpan(text: "Minecraft"),
            ),
          ),
          BotOption(
            message: const Text.rich(
              TextSpan(text: "Free Fire"),
            ),
          ),
          BotOption(
            message: const Text.rich(
              TextSpan(text: "Call of Duty"),
            ),
          ),
          BotOption(
            message: const Text.rich(
              TextSpan(text: "Fortinite"),
            ),
          ),
          BotOption(
            message: const Text.rich(
              TextSpan(text: "Geshin Impact"),
            ),
          ),
          BotOption(
            message: const Text.rich(
              TextSpan(text: "League of Legends Wild Rift"),
            ),
          ),
          BotOption(
            message: const Text.rich(
              TextSpan(text: "Asphalt 9"),
            ),
          ),
          BotOption(
            message: const Text.rich(
              TextSpan(text: "Candy Crush"),
            ),
          ),
          BotOption(
            message: const Text.rich(
              TextSpan(text: "PES 2021"),
            ),
          ),
          BotOption(
            message: const Text.rich(
              TextSpan(text: "Minecraft"),
            ),
          ),
          BotOption(
            message: const Text.rich(
              TextSpan(text: "Outros jogos"),
            ),
          ),
          BotOption(
            message: const Text.rich(
              TextSpan(text: "Nenhuma das opções acima"),
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
        const Text.rich(
          TextSpan(children: [
            TextSpan(
                text:
                    "Agora, sobre redes sociais, quais dos apps abaixo você faz uso mais frequente? "),
          ]),
        ),
      ],
      options: [
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Instagram"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Facebook"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Whatsapp"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Tik Tok"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Youtube"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Snapchat"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Twitter"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Outras Redes Sociais"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Nenhuma das opções acima"),
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
        const Text.rich(
          TextSpan(children: [
            TextSpan(text: "Entendi, interessante"),
          ]),
        ),
        const Text.rich(
          TextSpan(children: [
            TextSpan(
                text:
                    "Para fazer edição pelo smartphone, você faz uso de quais dos apps abaixo?"),
          ]),
        ),
      ],
      options: [
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Tik Tok"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Photoshop"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Canva"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Vimeo"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Inshot"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Capcut"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Outros app de edição"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Nenhuma das opções acima"),
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
        const Text.rich(
          TextSpan(children: [
            TextSpan(
                text:
                    "Lega, agora só mais uma pergunta antes deu te sugerir um modelo."),
          ]),
        ),
        const Text.rich(
          TextSpan(children: [
            TextSpan(
                text:
                    "Em relação a produtividade, quais dos apps abaixo você utiliza mais?"),
          ]),
        ),
      ],
      options: [
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Adobe Scam"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "CamScanner"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "PowerPoint"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Vimeo"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Google Docs"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Google Maps"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Outros app de produtividade"),
          ),
        ),
        BotOption(
          message: const Text.rich(
            TextSpan(text: "Nenhuma das opções acima"),
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

  BotStateSingleChoice _stateH() {
    return BotStateSingleChoice(
      id: "H",
      messages: () => [
        const Text.rich(
          TextSpan(children: [
            TextSpan(
                text: "Prontinho, finalizamos as perguntas, agora é comigo!"),
          ]),
        ),
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text:
                      "Com base nas suas respostas o smartphone que mais se adequa ao seu uso é "),
            ],
          ),
        ),
      ],
      transitions: [
        BotTransition(id: "H=>HImage", to: "HImage"),
      ],
      onEnter: (machine) async {
        await Future.delayed(const Duration(seconds: 1));
        machine.transitionTo("HImage");
      },
    );
  }

  BotStateImage _stateHImage() {
    return BotStateImage(
      id: "HImage",
      image: () => Image.network(
        "https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/iphone-13-pro-blue-select?wid=940&hei=1112&fmt=png-alpha&.v=1645552346275",
        fit: BoxFit.fill,
        loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? loadingProgress,
        ) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
      label: () => [
        Text.rich(
          TextSpan(
            text: smartPhoneModel,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      transition: BotTransition(id: "HImage=>I", to: "I"),
      onEnter: (machine) async {
        await Future.delayed(const Duration(seconds: 1));
        machine.transitionTo("I");
      },
    );
  }

  BotStateSingleChoice _stateI() {
    return BotStateSingleChoice(
      id: "I",
      messages: () => [
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "Adorei convensar com você!"),
            ],
          ),
        ),
        const Text.rich(
          TextSpan(children: [
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
          message: const Text.rich(TextSpan(text: "Sim")),
        ),
        BotTransition(
          id: "I=>K",
          to: "K",
          message: const Text.rich(TextSpan(text: "Não")),
        ),
      ],
    );
  }

  BotStateSingleChoice _stateJ() {
    return BotStateSingleChoice(
      id: "J",
      messages: () => [
        Text.rich(
          TextSpan(children: [
            TextSpan(text: "Que bom $userName!"),
          ]),
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(text: "Obrigado, e tenha um ótimo dia $userName!"),
          ]),
        ),
      ],
    );
  }

  BotStateSingleChoice _stateK() {
    return BotStateSingleChoice(
      id: "K",
      messages: () => [
        const Text.rich(
          TextSpan(children: [
            TextSpan(text: "Ahh que pena..."),
          ]),
        ),
        const Text.rich(
          TextSpan(children: [
            TextSpan(text: "Obrigado, e tenha um ótimo dia!"),
          ]),
        ),
      ],
    );
  }
}
