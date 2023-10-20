import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JoinGame extends StatefulWidget {
  const JoinGame({super.key});

  @override
  JoinGameState createState() => JoinGameState();
}

class JoinGameState extends State<JoinGame> {
  static const platform = MethodChannel('com.daysling.sxc_quiz/communicate');
  static const platformReceiver =
      MethodChannel('com.daysling.sxc_quiz/communicate-receiver');
  var text = "";
  var btnColor = Colors.grey;
  var isEnabled = false;
  @override
  void initState() {
    super.initState();
    platformReceiver.setMethodCallHandler((call) {
      if (call.method == "setBuzzPosition") {
        setState(() {
          text = "Buzz position: ${int.parse(call.arguments) + 1}";
        });
      }
      if (call.method == "resetBuzzer") {
        setState(() {
          btnColor = Colors.red;
          text = "";
          isEnabled = true;
        });
      }
      if (call.method == "lockBuzzer") {
        setState(() {
          btnColor = Colors.grey;
          isEnabled = false;
        });
      }
      if (call.method == "unlockBuzzer") {
        setState(() {
          btnColor = Colors.red;
          isEnabled = true;
        });
      }
      return Future.value();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Should contain a scrollable table with header User, Timestamp
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text("Quiz Begun!"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(text,
                  style: const TextStyle(fontSize: 30, color: Colors.white)),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              // add a circular button to reset buzzer
              ElevatedButton(
                onPressed: () {
                  // Handle reset button press
                  if (!isEnabled) return;
                  platform.invokeMethod('invokeBuzz');
                  isEnabled = false;
                  setState(() {
                    btnColor = Colors.grey;
                  });
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: btnColor,
                    padding: const EdgeInsets.all(80),
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minimumSize: const Size(350, 500)),
                child: const Text(
                  'BUZZER',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
            ],
          ),
        ));
  }
}
