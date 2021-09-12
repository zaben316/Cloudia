import 'package:bankapp/main.dart';
import 'package:flutter/material.dart';

import 'SpeechToText.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {

  TextToSpeech? textToSpeech;
  SpeechToText? speechToText;

  @override
  void initState() {
    setup();
    super.initState();
  }

  setup() async{
    textToSpeech = TextToSpeech.get((){setState(() {});});
    textToSpeech?.playText("Welcome, please say easy access if you want to continue with the Cloudia, or tap on 'Contiue WITHOUT Cloudia' to continue with the normal mode.");
    await Future.delayed(const Duration(seconds: 5), () => "1");
    speechToText = SpeechToText.get();
    speechToText?.start(trackText);
  }

  bool isF = false;

  trackText(text) async {
    String tt = text.toString().toLowerCase();
    if (tt.contains("easy") || tt.contains("access")) {
      print("TWOOO");
      await speechToText?.stop();
      await Future.delayed(const Duration(seconds: 2), () => "1");
      if(!isF){
        setState(() {
          isF = true;
        });
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => MyHomePage()
            ));

      }
    }
  }

  @override
  void dispose() {
    speechToText?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Image.asset("assets/logo.png", height: 150)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){

                }, child: Text("Continue WITHOUT Cloudia", style: TextStyle(fontSize: 40)),),
                SizedBox(width: 50),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyHomePage()
                  ));
                }, child: Text("Continue with Cloudia", style: TextStyle(fontSize: 40)),),
              ],
            ),
            Text("")
          ],
        ),
      ),
    );
  }
}
