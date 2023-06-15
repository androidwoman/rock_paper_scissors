import 'package:flutter/material.dart';
import 'package:untitled1/home_page/rock_paper_scissors_game.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
    ),
    debugShowCheckedModeBanner: false,
    home: const RockPaperScissorsGame(),
  ));
}
