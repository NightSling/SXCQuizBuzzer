import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'host.dart';
import 'join.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // add a png logo
            const Image(image: AssetImage('images/logo.png'), height: 170, width: 170),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            ElevatedButton(
              onPressed: () {
                // Change to host page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HostPage(title: 'Host Page')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Text(
                'Host',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle join button press
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JoinPage(title: 'Join Page')),
                );
              },
              // style best for this button
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).expansionTileTheme.backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Text(
                'Join',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 0.0, right: 10.0, left: 10.0),
        height: 60.0,
        child: const Text(
          'Made with  ❤️  by \nSushant Pangeni (ASD), Adhish Bhattarai (ASA),\n Aayush Adhikari (ASD)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),

    );
  }
}
