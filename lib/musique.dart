import 'package:flutter/foundation.dart';

class Musique {

  String titre;
  String artiste;
  String imagePath;
  String urlSong;

  Musique(
      this.titre,
      this.artiste,
      this.imagePath,
      this.urlSong
      )
  {
    this.titre = titre;
    this.artiste = artiste;
    this.imagePath = imagePath;
    this.urlSong = urlSong;
  }

}