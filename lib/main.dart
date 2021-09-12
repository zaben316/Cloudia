import 'dart:async';
import 'package:flutter/material.dart';
import 'Login.dart';
import 'SpeechToText.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _confidence = 0;
  String text = "";
  String oldText = "";
  SpeechToText? speechToText;
  TextToSpeech? textToSpeech;
  bool isSpeaking = false;
  bool processed = false;
  Timer? speakTimeOut;

  showLoader(BuildContext context) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context1) {
        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.orange),
                  ),
                  height: 40.0,
                  width: 40.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  hideLoader(){
    Navigator.of(context).pop();
  }

  String balance = "You currently have 3654 dollars and 65 cents in your checking account and 7556 dollars and 15 cents in your saving account, what else can i help you with today?";
  String bill = "You currently have one water bill, that costs 45 dollars, would you like to pay it?";

  processText(String text) async {
    print("text ========== $text");

    if(text.isNotEmpty){
      String tt = text.toLowerCase();
      print(tt);
      if(tt.contains("hi") || tt.contains("hello")){
        print("SAYING");
        await textToSpeech?.playText("Hello Suhaib my name is cloudia, what would you like me to help you with today?");
      }
      else if(tt.contains("bill") || tt.contains("bills")){
        print("SAYING");
        await textToSpeech?.playText(bill);
      }
      else if(tt.contains("balance")){
        print("SAYING");
        await textToSpeech?.playText(balance);
      }
      else if(tt.contains("yes")){
        print("SAYING");
        await textToSpeech?.playText("Water bill is paid, would you like something else?");
      }
      else if(tt.contains("exit") || tt.contains("thank")){
        print("SAYING");
        await textToSpeech?.playText("Goodbye, see you soon!");
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
      else{
        print("SAYING");
        await textToSpeech?.playText("Can you repeat that please");
      }

    }

    text = "text is processing !";
    setState(() {});
    // showLoader(context);
    await Future.delayed(const Duration(seconds: 1), () => "1");
    // speechToText?.start(catchText);
    // hideLoader();
  }

  @override
  void initState() {
    startVoice();
    super.initState();
  }

  stopReading() async{
    if(text.isNotEmpty){
      await speechToText?.stop();
      await Future.delayed(const Duration(seconds: 1), () => "1");
      await processText(text);
      await speechToText?.start(catchText);
    }
  }

  catchText(val) {
    setState(() {
      oldText = text;
      if(val.recognizedWords.toString().isNotEmpty)
        text = val.recognizedWords;
      if (val.hasConfidenceRating && val.confidence > 50) {
        _confidence = val.confidence;
      }
    });
  }

  void startVoice() async{
    speechToText = SpeechToText.get();
    textToSpeech = TextToSpeech.get((){setState(() {});});
    textToSpeech?.playText("What would you like to do today?");
    speechToText?.start(catchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/logo.png", height: 150),
            // Text(
            //   'acc: $_confidence',
            // ),
            Text(
              '$text',
              style: Theme.of(context).textTheme.headline4,
            ),
            MaterialButton(
              splashColor: Colors.white,
              enableFeedback: false,
              onPressed: (){
              stopReading();
            },
            child: Text(" "),)
          ],
        ),
      ),
    );
  }
}
