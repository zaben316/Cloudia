import 'dart:io';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SpeechToText {
  late stt.SpeechToText speech;
  static SpeechToText? _instance;
  late FlutterTts flutterTts;

  SpeechToText._(){
    speech = stt.SpeechToText();
  }

  static SpeechToText? get(){
    if(_instance == null){
      _instance = SpeechToText._();
    }
    return _instance;
  }



  start(onResult) async{
    bool available = await speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if ( available ) {
      speech.listen(
        onResult: onResult
      );
    }
    else {
      print("The user has denied the use of speech recognition.");
      speech.stop();
    }
  }

  stop() async{
    await speech.stop();
  }


}


class TextToSpeech{

  static TextToSpeech? _instance;
  late FlutterTts flutterTts;
  late Function callBack;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;

  TextToSpeech._(call){
    callBack = call;
    initTts();
  }

  static TextToSpeech? get(callBack){
    if(_instance == null){
      _instance = TextToSpeech._(callBack);
    }
    return _instance;
  }

  initTts() async{
    flutterTts = FlutterTts();
    await flutterTts.setSharedInstance(true);

    flutterTts.setStartHandler(() {
        print("Playing");
        callBack();
    });

    flutterTts.setCompletionHandler(() {
        print("Complete");
        callBack();
    });

    flutterTts.setCancelHandler(() {
        print("Cancel");
        callBack();
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
          print("Paused");
          callBack();
      });

      flutterTts.setContinueHandler(() {
          print("Continued");
          callBack();
      });
    }

    flutterTts.setErrorHandler((msg) {
        print("error: $msg");
        callBack();
    });
  }

  playText(newText) async{
    // await flutterTts.setVolume(1);
    // await flutterTts.setSpeechRate(0.3);
    // await flutterTts.setPitch(1.3);

    if (newText != null) {
      if (newText!.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(newText!);
      }
    }
  }
}