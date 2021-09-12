import 'package:bankapp/ScreenOne.dart';
import 'package:bankapp/main.dart';
import 'package:flutter/material.dart';

import 'SpeechToText.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  SpeechToText? speechToText;
  TextToSpeech? textToSpeech;

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

  @override
  void initState() {
    textToSpeech = TextToSpeech.get((){setState(() {});});
    textToSpeech?.playText("Welcome, please tap your card and then scan you fingerprint on the area");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Image.asset("assets/logo.png", height: 150),
          SizedBox(height: 40),
          Text("Please tap your card", textAlign: TextAlign.center, style: TextStyle(fontSize: 40),),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/scree1.png"),
              Image.asset("assets/scree2.png"),
            ],
          ),
          SizedBox(height: 40),
          Text("and then put your fingerprint", textAlign: TextAlign.center, style: TextStyle(fontSize: 40),),
          SizedBox(height: 40),
          InkWell(
              child: Image.asset("assets/touch.png", height: 75,),
              onTap: () async{

                showLoader(context);
                await Future.delayed(const Duration(seconds: 3), () => "1");
                hideLoader();
                await Future.delayed(const Duration(milliseconds: 500), () => "1");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ScreenOne()
                  )
                );
              },
          ),

        ],
      ),
    );
  }
}
