import 'package:flutter/material.dart';
import 'package:white_tile/game.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
            child: Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return GamePage();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  onPrimary: Colors.white,
                  onSurface: Colors.grey,
                ),
                child: const Text('Play'),
              ),
              TextButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  onPrimary: Colors.white,
                  onSurface: Colors.grey,
                ),
                child: const Text('Quit'),
              ),
            ],
          ),
        )));
  }
}
