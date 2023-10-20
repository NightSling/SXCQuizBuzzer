import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sxc_quiz/host-game.dart';

class HostPage extends StatefulWidget {
  const HostPage({super.key, required this.title});

  final String title;

  @override
  HostPageState createState() => HostPageState();
}

class HostPageState extends State<HostPage> {
  bool isBluetoothLoaded = false;
  bool isError = false;
  String errMessage = "";
  String textMessage = "Connected Devices";
  // create a string list
  static const platform = MethodChannel('com.daysling.sxc_quiz/communicate');
  static const platformReceiver = MethodChannel('com.daysling.sxc_quiz/communicate-receiver');

  final List<String> _devices = [];

  @override
  void initState() {
    super.initState();
    // Global UUID For Child Service
    // b'\x00\xf2\xd0\x1a\xcf\x04OR\x96\xd8\x1a\x19\xc0^\xd7\x17'
    // UUID('00f2d01a-cf04-4f52-96d8-1a19c05ed717')
    platform.invokeMethod("startServer");
    platformReceiver.setMethodCallHandler((call) {
      if (call.method == "onDeviceConnect") {
        setState(() {
          _devices.add(call.arguments);
        });
      }
      if (call.method == "onDeviceDisconnect") {
        setState(() {
          _devices.remove(call.arguments);
        });
      }
      return Future.value();
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isError) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Error: $errMessage"),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.title),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
              // Add A big text that says Connected Devices.
              Align(
                child: Column(
                  children: [
                    // add a button to Host Quiz
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        platform.invokeMethod("startGame");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HostGame()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      ),
                      child: const Text('Host Quiz'),
                    ),
                    // padding,
                    const SizedBox(height: 20),

                    Text(textMessage, style: const TextStyle(fontSize: 30)),
                    for (var device in _devices) Text(device, style: const TextStyle(fontSize: 20)),
                  ]
                )
              ),

          ],
        ),
    );
  }
}
