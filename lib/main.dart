import 'dart:ffi';
import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
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
  MyHomePage({Key key, this.title}) : super(key: key);

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

  AudioPlayer audioPlayer;
  StreamSubscription positionSub;
  StreamSubscription stateSubscription;

  Musique maMusiqueActuelle;
  Duration position = new Duration(seconds: 0);
  Duration duree = new Duration(seconds: 10);
  PlayerState statut = PlayerState.stopped;
  int index = 0;

  @override
  void initState() {
    super.initState();
    maMusiqueActuelle = maListeDeMusiques[0];
    configurationAudioPlayer();
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
                bouton(
                    (statut == PlayerState.playing)
                        ? Icons.pause
                        : Icons.play_arrow,
                    80.0,
                    (statut == PlayerState.playing)
                        ? ActionMusic.pause
                        : ActionMusic.play),
                bouton(Icons.fast_forward, 30.0, ActionMusic.forward)
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                texteAvecStyle(fromDuration(position), 1.0),
                texteAvecStyle(fromDuration(duree), 1.0),
              ],
            ),
            new Slider(
                value: position.inSeconds.toDouble(),
                min: 0.0,
                max: 30.0,
                inactiveColor: Colors.white,
                activeColor: Colors.red,
                onChanged: (double d) {
                  setState(() {
                    // Duration nouvelleDuration =
                    //     new Duration(seconds: d.toInt());
                    // position = nouvelleDuration;
                    audioPlayer.seek(d);
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
              play();
              print((' play(///////////////////////////////);'));
              break;
            case ActionMusic.pause:
              pause();
              print(('pause(///////////////////////////////);'));
              break;
            case ActionMusic.forward:
              forward();
              print(('forward(/////////////////////////////);'));
              break;
            case ActionMusic.rewind:
              rewind();
              print(('rewind(////////////////////////////////);'));
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

  void configurationAudioPlayer() {
    audioPlayer = new AudioPlayer();
    positionSub = audioPlayer.onAudioPositionChanged
        .listen((pos) => setState(() => position = pos));
    stateSubscription = audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.PLAYING) {
        setState(() {
          duree = audioPlayer.duration;
        });
      } else if (state == AudioPlayerState.STOPPED) {
        setState(() {
          statut = PlayerState.stopped;
        });
      }
    }, onError: (message) {
      print('erreur: $message');
      setState(() {
        statut = PlayerState.stopped;
        duree = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    await audioPlayer.play(maMusiqueActuelle.urlSong);
    setState(() {
      statut = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() {
      statut = PlayerState.paused;
    });
  }

  void forward() {
    if (index == maListeDeMusiques.length - 1) {
      index = 0;
    } else {
      index++;
    }
    maMusiqueActuelle = maListeDeMusiques[index];
    audioPlayer.stop();
    configurationAudioPlayer();
    play();
  }

  String fromDuration(Duration duree){
    print(duree);
   return duree.toString().split('.').first;
  }


  void rewind() {
    if (position > Duration(seconds: 3)) {
      audioPlayer.seek(0.0);
    } else {
      if (index == 0) {
        index = maListeDeMusiques.length - 1;
      } else {
        index--;
      }
      maMusiqueActuelle = maListeDeMusiques[index];
      audioPlayer.stop();
      configurationAudioPlayer();
      play();
    }
  }
}

enum ActionMusic { play, pause, rewind, forward }

enum PlayerState { playing, stopped, paused }
