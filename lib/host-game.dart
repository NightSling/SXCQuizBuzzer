import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HostGame extends StatefulWidget {
  const HostGame({super.key});

  @override
  HostGameState createState() => HostGameState();
}

class HostGameState extends State<HostGame> {
  static const platform = MethodChannel('com.daysling.sxc_quiz/communicate');
  static const platformReceiver =
      MethodChannel('com.daysling.sxc_quiz/communicate-receiver');

  var isLocked = true;
  var aText = 'Unlock Buzzer';
  var list = [
    const DataRow(
      cells: [
        DataCell(Text('Buzzer Locked')),
        DataCell(Text('Click Reset Buzzer & Unlock Buzzer to begin!')),
      ],
    )
  ];

  @override
  void initState() {
    super.initState();
    platformReceiver.setMethodCallHandler((call) {
      if (call.method == "onBuzz") {
        // get current unix timestamp
        var matches =
            (RegExp(r'^([0-9])#(.*)$')).firstMatch(call.arguments as String);
        var name = matches?.group(2);
        var timeStamp = DateTime.now().millisecondsSinceEpoch;
        setState(() {
          list.add(DataRow(cells: [
            DataCell(Text("$name")),
            DataCell(Text("$timeStamp")),
          ]));
        });
      }
      return Future.value();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Should contain a scrollable table with header User, Timestamp
    var dataTable = DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'User',
              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 20),
            ),
          ),
          DataColumn(
            label: Text(
              'Timestamp',
              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 20),
            ),
          ),
        ],
        rows: list,
        border: TableBorder.all(
          color: Colors.white,
          width: 2,
          style: BorderStyle.solid,
        ));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text("Quiz Begun!"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: dataTable,
                ),
              ),
              // adding padding
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              // add a circular button to reset buzzer
              ElevatedButton(
                onPressed: () {
                  // Handle reset button press
                  platform.invokeMethod('resetBuzzer');
                  setState(() {
                    list.clear();
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(20), // <-- Splash color
                ),
                child: const Text(
                  'Reset Buzzer',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              ElevatedButton(
                onPressed: () {
                  // Handle reset button press
                  if (isLocked) {
                    isLocked = false;
                    setState(() {
                      aText = "Lock Buzzer";
                    });
                    platform.invokeMethod('unlockBuzzer');
                  } else {
                    isLocked = true;
                    setState(() {
                      aText = "Unlock Buzzer";
                    });
                    platform.invokeMethod('lockBuzzer');
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.all(20), // <-- Splash color
                ),
                child: Text(
                  aText,
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}
