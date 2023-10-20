import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sxc_quiz/join-game.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key, required this.title});

  final String title;

  @override
  JoinPageState createState() => JoinPageState();
}

class JoinPageState extends State<JoinPage> {
  bool isError = false;
  String errMessage = "";
  static const platform = MethodChannel('com.daysling.sxc_quiz/communicate');
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Global UUID For Child Service
    // b'\x00\xf2\xd0\x1a\xcf\x04OR\x96\xd8\x1a\x19\xc0^\xd7\x17'
    // UUID('00f2d01a-cf04-4f52-96d8-1a19c05ed717')
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isError) {
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
              child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Put Team Name',
                ),
                controller: myController,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Respond to button press
                setState(() {
                  platform.invokeMethod("joinServer", myController.text).then((value) {
                    myController.text = value as String;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const JoinGame()));
                });

              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))), minimumSize: MaterialStateProperty.all<Size>(const Size(200, 50))),
              child: const Text('Join',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ])),
        ],
      ),
    );
  }
}
