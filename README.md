# Flutter Chat Composer

>How about transforming your state machine into a chat bot? Flutter Chat Composer makes use of state machines generated by <a href="https://github.com/FelipeMarra/state-composer">state_composer<a> to create chatbots based on those states

# Usage

## Creating the chat's state machine

A chat bot is composed of states. Let's recreate the simple one that's in our <a href="https://github.com/FelipeMarra/flutter_chat_composer/tree/main/example">example<a> folder. <br>

First we'll declare our initial state and functions that we'll use to create our states isolated:

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
### State Types and Properties
First you should know general state properties. They will have an id, onEnter/onLeave functions, and transitions like in  <a href="https://github.com/FelipeMarra/state-composer">state_composer<a>, and generally something to show to the user and receive it's input in return.<br>

Currently we have 4 state types, let's add one of each in our bot.<br>

### Open Text State

State A will introduce our bot to the user, and ask his name. As you can see `BotStateOpenText` type has a `decideTransition` property, which will give you the text typed by the user so you can decide what transition to make. In our <a href="https://github.com/FelipeMarra/flutter_chat_composer/tree/main/example">example<a> we'll run _stateADecision wich will say to our machine to transition to the state ALoop till the user say his name. When the text is not empty will go to state B. Remember that a state can only transition to another that is inside its transition list, otherwise it will throw an error. <br>

Another very important thing is that instead of text or richText widgets we use `MarkdownBody` from the <a href="https://pub.dev/packages/flutter_markdown">flutter_markdown<a> package. It allows us to render markdown - like the one I'm using right now to write this README.md file - in a very easy way, avoiding all the boilerplate code that would be needed otherwise.

``` dart 
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
        MarkdownBody(data: "Hi, I'm **$botName**, what is your name?"),
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
        const MarkdownBody(data: "I reeeally need to know your name..."),
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
```

<img src="https://media.giphy.com/media/OFIoNoMwjmUnfUKheb/giphy.gif" width="360" height="460" />

### Single Choice State
State B will use `BotStateSingleChoice` to make the user choose a pokemon gif that will be shown in state C. When the option is selected `onChange` function will be executed followed by the transition to the next state decided by the `decideTransition` callback, that will give you the selected option and ask a state id in return - that id must me in your transitions list.

``` dart 
  BotStateSingleChoice _stateB() {
    return BotStateSingleChoice(
      id: "B",
      messages: () => [
        MarkdownBody(data: "Ok, $userName what pokemon would you choose"),
      ],
      options: [
        BotOption(
          message: const MarkdownBody(data: "Bulbassaur"),
          onChange: (option) => choosenPokemonGif =
              "https://i.pinimg.com/originals/62/a6/94/62a694968a8a3a1842c4b9a79d5aa5c1.gif",
        ),
        BotOption(
          message: const MarkdownBody(data: "Charmander"),
          onChange: (option) => choosenPokemonGif =
              "https://i.pinimg.com/originals/37/08/62/370862bbff7f3d3345a3d0e9b45a38c3.gif",
        ),
        BotOption(
          message: const MarkdownBody(data: "Squirtle"),
          onChange: (option) => choosenPokemonGif =
              "https://i.pinimg.com/originals/24/e2/e7/24e2e7c933f4f0f11dac65521a9c4a29.gif",
        ),
      ],
      transitions: [
        BotTransition(id: "B=>C", to: "C"),
      ],
      decideTransition: (BotOption selectedOptions) => "C",
    );
  }
```

### Image State
State C will show the image and transition to the next state after 1 second <br>
Of course in this state we use an `Image` widget instead of Markdow

``` dart 
  BotStateImage _stateC() {
    return BotStateImage(
      id: "C",
      image: () => Image.network(
        choosenPokemonGif,
        fit: BoxFit.fill,
        loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? loadingProgress,
        ) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      onEnter: (machine) async {
        await Future.delayed(const Duration(seconds: 1));
        machine.transitionTo("D");
      },
      transition: BotTransition(id: "C=>D", to: "D"),
    );
  }
```

And yes, alternatively, since Markdown supports images you could use something like `BotStateSingleChoice` without passing the options. And that is not only less semantic but also will not have stuff like `Image.network`'s `loadingBuilder` for example.

``` dart 
  BotStateSingleChoice _stateC() {
    return BotStateSingleChoice(
      id: "C",
      messages: () => [
        MarkdownBody(data: "![foo]($choosenPokemonGif)"),
      ],
      onEnter: (machine) async {
        await Future.delayed(const Duration(seconds: 1));
        machine.transitionTo("D");
      },
      transitions: [
        BotTransition(id: "C=>D", to: "D"),
      ],
      decideTransition: (option) => "D",
    );
  }
```

<img src="https://media.giphy.com/media/7QaUEutJSBqpwh9bJk/giphy.gif" width="360" height="460" />

Ps: had to run `flutter run -d chrome --web-renderer html` so that Image.network could display the gifs

### Multiple Choice State
What about being allowed to choose more than one option? Presenting the Multiple Choice State. State D will use it to ask a little bit more about the user's pokemon taste. `BotOption` comes with a `onChange` callback as already shown, and you can also use a custom `validator` that gives you the selected `BotOption`s and works like any other form validator. `decideTransition` also gives you the selected options so you can return who the next state will be.

``` dart
  BotStateMultipleChoice _stateD() {
    return BotStateMultipleChoice(
      id: "D",
      messages: () => [
        const MarkdownBody(data: "That was a wise choice!"),
        const MarkdownBody(data: "What 3 other pokemons you like most?"),
      ],
      options: () => [
        BotOption(message: const MarkdownBody(data: "Pikachu")),
        BotOption(message: const MarkdownBody(data: "Eevee")),
        BotOption(message: const MarkdownBody(data: "Charizard")),
        BotOption(message: const MarkdownBody(data: "Mewtwo")),
        BotOption(message: const MarkdownBody(data: "Gengar")),
        BotOption(message: const MarkdownBody(data: "Lucario")),
      ],
      validator: (options) {
        if (options.length != 3) {
          return "Select 3 options";
        }
        return null;
      },
      transitions: [
        BotTransition(id: "D=>E", to: "E"),
      ],
      decideTransition: (options) => "E",
    );
  }
```

### Single Choice Without Transition
If you want to say something then just say it! `BotStateSingleChoice` don't need transitions and options, so you can use just its messages:

``` dart 
  BotStateSingleChoice _stateE() {
    return BotStateSingleChoice(
      id: "E",
      messages: () => [
        const MarkdownBody(data: "Very interesting choices!"),
        MarkdownBody(data: "Bye bye, $userName, it was nice talking to you!"),
      ],
    );
  }
```

<img src="https://media.giphy.com/media/FKdrNVeGF2QrQMeWvV/giphy.gif" width="360" height="460" />

Ps: Soon there will be a simple state just to display simple markdowns and stop this thing of using `BotStateSingleChoice` for that purpose

## Creating the UI
The UI is created using the `ChatBotWidget`, it already comes with predefined widgets to show everything you need, but you can customize all of them.

``` dart 
class ChatBotInteractionApp extends StatelessWidget {
  const ChatBotInteractionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatBot chatBot = MyChatBot().chatBot();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("My ChatBot"),
          centerTitle: true,
        ),
        body: ChatBotWidget(
          chatBot: chatBot,
          sameUserSpacing: 3,
        ),
      ),
    );
  }
}
```
