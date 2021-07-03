import 'dart:ffi';

import 'package:flutter/material.dart';
import 'musique.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coda Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Coda Music'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Musique> maListeDeMusiques = [
    new Musique('Theme Swift', 'Codabee', 'assets/un.jpg',
        'https://codabee.com/wp-content/uploads/2018/06/un.mp3'),
    new Musique('Theme Flutter', 'Codabee', 'assets/deux.jpg',
        'https://codabee.com/wp-content/uploads/2018/06/deux.mp3'),
  ];
  late Musique maMusiqueActuelle;
  double position = 0.0;
  @override
  void initState() {
    super.initState();
    maMusiqueActuelle = maListeDeMusiques[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[600],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Card(
              elevation: 9.0,
              child: new Container(
                width: MediaQuery.of(context).size.height / 2.5,
                child: new Image.asset(maMusiqueActuelle.imagePath),
              ),
            ),
            texteAvecStyle(maMusiqueActuelle.titre, 1.6),
            texteAvecStyle(maMusiqueActuelle.artiste, 1.3),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                bouton(Icons.fast_rewind, 30.0, ActionMusic.rewind),
                bouton(Icons.play_arrow, 40.0, ActionMusic.play),
                bouton(Icons.fast_forward, 30.0, ActionMusic.forward)
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                texteAvecStyle('0:0', 1.0),
                texteAvecStyle('0:22', 1.0),
              ],
            ),
            new Slider(
                value: position,
                min: 0.0,
                max: 30.0,
                inactiveColor: Colors.white,
                activeColor: Colors.red,
                onChanged: (double d) {
                  setState(() {
                    position = d;
                  });
                })
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  IconButton bouton(IconData icone, double taille, ActionMusic action) {
    return new IconButton(
        iconSize: taille,
        color: Colors.white,
        icon: new Icon(icone),
        onPressed: () {
          switch (action) {
            case ActionMusic.play:
              print(('play'));
              break;
            case ActionMusic.pause:
              print(('pause();'));
              break;
            case ActionMusic.forward:
              print(('forward();'));
              break;
            case ActionMusic.rewind:
              print(('rewind();'));
              break;
          }
        });
  }

  Text texteAvecStyle(String data, double scale) {
    return new Text(
      data,
      textScaleFactor: scale,
      textAlign: TextAlign.center,
      style: new TextStyle(
          color: Colors.limeAccent,
          fontSize: 20.0,
          fontStyle: FontStyle.italic),
    );
  }
}

enum ActionMusic { play, pause, rewind, forward }
