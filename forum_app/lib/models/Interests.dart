import 'package:flutter/material.dart';
import 'package:forum_app/models/interest.dart';

class Interests {
    static List<Interest> list = [
      Interest("Веселье", const Icon(Icons.emoji_emotions_outlined, color: Colors.cyan), Colors.yellow[400]),
      Interest("Спорт", const Icon(Icons.sports_outlined, color: Colors.cyan), Colors.blue[400]),
      Interest("Лайфхаки", const Icon(Icons.highlight_outlined, color: Colors.cyan), Colors.green[400]),
      Interest("Животные", const Icon(Icons.cruelty_free_outlined, color: Colors.cyan), Colors.orange[400]),
      Interest("Игры", const Icon(Icons.games_outlined, color: Colors.cyan), Colors.blueGrey[400]),
      Interest("TV", const Icon(Icons.live_tv_outlined, color: Colors.cyan), Colors.grey[400]),
      Interest("Музыка", const Icon(Icons.library_music_outlined, color: Colors.cyan), Colors.red[300]),
      Interest("IT", const Icon(Icons.computer_outlined, color: Colors.cyan), Colors.lightBlue[400]),
      Interest("Кухня", const Icon(Icons.cookie_outlined, color: Colors.cyan), Colors.orange[400]),
      Interest("Спортзал", const Icon(Icons.sports_gymnastics_outlined, color: Colors.cyan), Colors.blueAccent[400]),
      Interest("Путешествие", const Icon(Icons.travel_explore_outlined, color: Colors.cyan), Colors.greenAccent[400]),
      Interest("Транспорт", const Icon(Icons.car_repair_outlined, color: Colors.cyan), Colors.blue[400]),
    ];
}