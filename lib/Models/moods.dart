import 'package:flutter/material.dart';

class Moods {
  final String title;
  final Color color;
  final double rotation;
  final IconData icon;

  const Moods({this.title, this.color, this.rotation, this.icon});

  IconData getMoodIcon(String mood) {
    return _moodsList[_moodsList.indexWhere((icon) => icon.title == mood)].icon;
  }

  Color getMoodColor(String mood) {
    return _moodsList[_moodsList.indexWhere((icon) => icon.title == mood)]
        .color;
  }

  double getMoodRotation(String mood) {
    return _moodsList[_moodsList.indexWhere((icon) => icon.title == mood)]
        .rotation;
  }

  List<IconData> getMoodIconList() {
    List<IconData> moodIconList = [];
    for (int i = 0; i < _moodsList.length; i++) {
      moodIconList.add(_moodsList[i].icon);
    }
    return moodIconList;
  }

  List<String> getMoodTitleList() {
    List<String> moodTitleList = [];
    for (int i = 0; i < _moodsList.length; i++) {
      moodTitleList.add(_moodsList[i].title);
    }
    return moodTitleList;
  }
}

List<Moods> _moodsList = <Moods>[
  Moods(
      title: 'Terrible',
      color: Colors.grey[300],
      rotation: 0.2,
      icon: Icons.sentiment_very_dissatisfied),
  Moods(
      title: 'Bad',
      color: Colors.blueGrey,
      rotation: 0.0,
      icon: Icons.sentiment_dissatisfied),
  Moods(
      title: 'Neutral',
      color: Colors.cyan[200],
      rotation: -0.2,
      icon: Icons.sentiment_neutral),
  Moods(
      title: 'Good',
      color: Colors.yellow,
      rotation: -0.4,
      icon: Icons.sentiment_satisfied),
  Moods(
      title: 'Wonderful',
      color: Colors.green,
      rotation: -0.4,
      icon: Icons.sentiment_very_satisfied)
];
