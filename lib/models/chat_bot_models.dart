import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:state_composer/state_composer.dart';

///A [StateMachine] that represents the chat bot
class ChatBot extends StateMachine<BotStateBase> {
  List<BotStateBase> history = [];

  ChatBot({
    required String id,
    required List<BotStateBase> states,
    required String initialStateId,
    historyMode = false,
  }) : super(
          id: id,
          states: states,
          initialStateId: initialStateId,
          historyMode: historyMode,
        ) {
    if (historyMode) {
      history = states;
    }
  }

  Future<Map<String, dynamic>> getMessageHistoryMap() async {
    Map<String, dynamic> historyMap = {};

    historyMap["id"] = id;
    for (BotStateBase botState in history) {
      Map<String, dynamic> map = await botState.getMessageHistoryMap();
      historyMap[botState.id] = map;
    }
    return historyMap;
  }

  static ChatBot fromMessageHistoryMap(Map<String, dynamic> map) {
    List<BotStateBase> states = [];

    map.forEach((key, stateData) {
      //TODO use a metadata proprierty to save stuff like id, user name, etc
      if (key != "id") {
        BotStateBase state;
        switch (stateData["type"]) {
          case "BotStateSingleChoice":
            state = BotStateSingleChoice.fromMessageHistoryMap(stateData);
            break;
          case "BotStateMultipleChoice":
            state = BotStateMultipleChoice.fromMessageHistoryMap(stateData);
            break;
          case "BotStateImage":
            state = BotStateImage.fromMessageHistoryMap(stateData);
            break;
          case "BotStateOpenText":
            state = BotStateOpenText.fromMessageHistoryMap(stateData);
            break;
          default:
            state = BotStateBase.fromMessageHistoryMap(stateData);
        }
        states.add(state);
      }
    });

    return ChatBot(
      id: map["id"],
      states: states,
      historyMode: true,
      initialStateId: "",
    );
  }
}

///The base class of the  [ChatBot]'s states
class BotStateBase extends ComposerState<BotTransition> {
  BotStateBase({
    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    List<BotTransition>? transitions,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotStateBase nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transitions ?? [],
          onEnter: (machine) {
            if (onEnter != null) {
              onEnter(machine as ChatBot);
            }
          },
          onLeave: (machine, nextState) {
            if (onLeave != null) {
              onLeave(machine as ChatBot, nextState as BotStateBase);
            }
          },
        );

  Future<Map<String, dynamic>> getMessageHistoryMap() async {
    return {
      "type": "BotStateBase",
      "id": id,
    };
  }

  static BotStateBase fromMessageHistoryMap(Map<String, dynamic> map) {
    return BotStateBase(id: map["id"]);
  }
}

///A state of the [ChatBot] that allows user to choose one option in a menu generated
///using its transitions list (the option message is the transition message)
class BotStateSingleChoice extends BotStateBase {
  ///Options that will be displayed
  final List<BotOption> Function()? options;

  ///Function that will take the user's selection and return to what state that
  ///the bot will go to
  final String Function(BotOption selectedOption)? decideTransition;

  ///Message selected by the user, for storage purposes
  int optionSelectedByUser;

  ///A a list of [MarkdownBody], each message is showed separated
  final List<MarkdownBody> Function() messages;

  BotStateSingleChoice({
    this.options,
    this.optionSelectedByUser = -1,
    this.decideTransition,
    required this.messages,

    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    List<BotTransition>? transitions,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotStateBase nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transitions,
          onEnter: onEnter,
          onLeave: onLeave,
        );

  @override
  Future<Map<String, dynamic>> getMessageHistoryMap() async {
    return {
      "type": "BotStateSingleChoice",
      "id": id,
      "botMessages": messages().map((x) => x.data).toList(),
      "userMessages": optionSelectedByUser > -1
          ? [options!()[optionSelectedByUser].message.data]
          : []
    };
  }

  static BotStateSingleChoice fromMessageHistoryMap(Map<String, dynamic> map) {
    List<MarkdownBody> botMessages = [];

    for (String message in map["botMessages"]) {
      botMessages.add(MarkdownBody(data: message));
    }
    

    bool theresUserMessage = map["userMessages"] != null && map["userMessages"].isNotEmpty;

    return BotStateSingleChoice(
      id: map["id"],
      messages: () => botMessages,
      options: () {
        if (theresUserMessage) {
          return [
            BotOption(
              message: MarkdownBody(data: map["userMessages"][0]),
            )
          ];
        }
        return [];
      },
      optionSelectedByUser: theresUserMessage ? 0 : -1,
    );
  }
}

///A state of the [ChatBot] that will allow to select multiple choices as the answer
class BotStateMultipleChoice extends BotStateBase {
  ///Function that will take the user's selection and return to what state that
  ///the bot will go to
  final String Function(List<BotOption> selectedOptions) decideTransition;

  ///Options that will be displayed
  final List<BotOption> Function() options;

  ///Options the user selected, for storage purposes
  List<int>? optionsSelectedByUser;

  ///To validade the options
  final String? Function(List<BotOption>)? validator;

  ///A a list of [MarkdownBody], each message is showed separated
  final List<MarkdownBody> Function() messages;

  BotStateMultipleChoice({
    required this.options,
    required this.decideTransition,
    required this.messages,
    this.optionsSelectedByUser,
    this.validator,

    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    required List<BotTransition> transitions,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotStateBase nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transitions,
          onEnter: onEnter,
          onLeave: onLeave,
        ) {
    optionsSelectedByUser ??= [];
  }

  @override
  Future<Map<String, dynamic>> getMessageHistoryMap() async {
    return {
      "type": "BotStateMultipleChoice",
      "id": id,
      "botMessages": messages().map((x) => x.data).toList(),
      "userMessages": optionsSelectedByUser!
          .map((index) => options()[index].message.data)
          .toList()
    };
  }

  static BotStateMultipleChoice fromMessageHistoryMap(
      Map<String, dynamic> map) {
    List<MarkdownBody> botMessages = [];

    for (String message in map["botMessages"]) {
      botMessages.add(MarkdownBody(data: message));
    }

    List<BotOption> options = [];
    List<int> optionsSelectdByUser = [];
    int counter = 0;
    for (String message in map["userMessages"]) {
      options.add(
        BotOption(
          message: MarkdownBody(data: message),
        ),
      );
      optionsSelectdByUser.add(counter);
      counter++;
    }

    return BotStateMultipleChoice(
      id: map["id"],
      messages: () => botMessages,
      options: () => options,
      optionsSelectedByUser: optionsSelectdByUser,
      transitions: [],
      decideTransition: (a) => "",
    );
  }
}

///A state of the [ChatBot] that will display a image and have no user interaction
///(use onEnter or onLeave to perform some login to go to the next state like a [Future.delayed])
class BotStateImage extends BotStateBase {
  ///Image to be displayed
  final Image Function() image;

  ///[image]'s label
  final List<MarkdownBody> Function()? label;

  BotStateImage({
    required this.image,
    this.label,

    ///The state's name (it's unique identifier)
    required String id,

    ///Transition to go to the other state
    BotTransition? transition,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotStateBase nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transition != null ? [transition] : [],
          onEnter: onEnter,
          onLeave: onLeave,
        );

  //TODO only working for network image
  // Future<String> _imageToBase64String(Image image) async {
  //   ImageProvider imageProvider = image.image;
  //   var type = imageProvider.runtimeType;
  //   //AssetImage
  //   if (type.toString() == "AssetImage") {
  //     AssetImage assetImage = imageProvider as AssetImage;
  //     ByteData byteData = await rootBundle.load(assetImage.assetName);
  //     return base64Encode(Uint8List.view(byteData.buffer));
  //   }
  //   //FileImage
  //   if (type.toString() == "FileImage") {
  //     FileImage fileImage = imageProvider as FileImage;
  //     Uint8List uintList = await fileImage.file.readAsBytes();
  //     return base64Encode(uintList.toList());
  //   }
  //   //NetworkImage
  //   if (type.toString() == "NetworkImage") {
  //     NetworkImage fileImage = imageProvider as NetworkImage;
  //     print("THE URI ${Uri.parse(fileImage.url)}");
  //     http.Response response = await http.get(
  //       Uri.parse(fileImage.url),
  //       headers: {
  //         "Accept": "application/json",
  //         "Access-Control_Allow_Origin": "*",
  //         "Access-Control-Allow-Methods": "*",
  //         "Access-Control-Allow-Headers":
  //             "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  //         //"Access-Control-Allow-Credentials": "true",
  //       },
  //     );
  //     final bytes = response.bodyBytes;
  //     print("THE BASE64 ${base64Encode(bytes)}");
  //     return base64Encode(bytes);
  //   }
  //   //MemoryImage
  //   if (type.toString() == "MemoryImage") {
  //     MemoryImage fileImage = imageProvider as MemoryImage;
  //     return base64Encode(fileImage.bytes);
  //   }

  //   return "ERROR: The type ${type.toString()} had no match";
  // }

  String _imageUrl(Image image) {
    NetworkImage fileImage = image.image as NetworkImage;
    return fileImage.url;
  }

  @override
  Future<Map<String, dynamic>> getMessageHistoryMap() async {
    return {
      "type": "BotStateImage",
      "id": id,
      "botMessages": [_imageUrl(image())],
      "userMessages": []
    };
  }

  static Image _imageFromBase64String(String imageURL) {
    return Image.network(imageURL);
  }

  static BotStateImage fromMessageHistoryMap(Map<String, dynamic> map) {
    String image = map["botMessages"][0];

    return BotStateImage(
      id: map["id"],
      image: () => _imageFromBase64String(image),
    );
  }
}

///A state of the [ChatBot] that will have a open text as the user's answer
class BotStateOpenText extends BotStateBase {
  ///Function that will take the user's input and return to what state the bot
  ///will go
  String Function(String userText) decideTransition;

  ///Text typed by the user, for storage purposes
  String? userText;

  ///A a list of [MarkdownBody], each message is showed separated
  final List<MarkdownBody> Function() messages;

  ///Validadte the text field
  final String? Function(String value)? validator;

  BotStateOpenText({
    required this.decideTransition,
    required this.messages,
    this.userText,
    this.validator,

    ///The state's name (it's unique identifier)
    required String id,

    ///Transitions options to go to the other states
    required List<BotTransition> transitions,

    ///Function executed when the state is entered
    Function(ChatBot stateMachine)? onEnter,

    ///Function executed when the state is left
    Function(ChatBot chatBot, BotStateBase nextState)? onLeave,
  }) : super(
          id: id,
          transitions: transitions,
          onEnter: onEnter,
          onLeave: onLeave,
        );

  @override
  Future<Map<String, dynamic>> getMessageHistoryMap() async {
    return {
      "type": "BotStateOpenText",
      "id": id,
      "botMessages": messages().map((x) => x.data).toList(),
      "userMessages": [userText]
    };
  }

  static BotStateOpenText fromMessageHistoryMap(Map<String, dynamic> map) {
    List<MarkdownBody> botMessages = [];

    for (String message in map["botMessages"]) {
      botMessages.add(MarkdownBody(data: message));
    }

    String? userText = map["userMessages"][0];

    return BotStateOpenText(
      id: map["id"],
      messages: () => botMessages,
      userText: userText,
      transitions: [],
      decideTransition: (a) => "",
    );
  }
}

///Represents a [BotStateMultipleChoice] option
class BotOption {
  ///Option text
  final MarkdownBody message;

  ///Call back for when this option is selected or unselected
  final Function(BotOption option)? onChange;

  ///If the option is currently selected, defaults to false
  bool selected;

  BotOption({
    required this.message,
    this.onChange,
    this.selected = false,
  });
}

///A transition [to] another [BotState]
///Should receive a message if it's a [BotStateSingleChoice]'s transition
class BotTransition extends Transition {
  BotTransition({
    required String id,
    required String to,
  }) : super(
          id: id,
          to: to,
        );
}
