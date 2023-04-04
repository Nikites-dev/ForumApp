import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum_app/models/interest.dart';

class Interests {
    static List<Interest> list = const [
      Interest("Funny", Icon(Icons.emoji_emotions_outlined, color: Colors.cyan)),
      Interest("Sport", Icon(Icons.sports_outlined, color: Colors.cyan)),
      Interest("Lifehacks", Icon(Icons.highlight_outlined, color: Colors.cyan)),
      Interest("Animals", Icon(Icons.cruelty_free_outlined, color: Colors.cyan)),
      Interest("Gaming", Icon(Icons.games_outlined, color: Colors.cyan)),
      Interest("TV", Icon(Icons.live_tv_outlined, color: Colors.cyan)),
      Interest("Music", Icon(Icons.library_music_outlined, color: Colors.cyan)),
      Interest("IT", Icon(Icons.computer_outlined, color: Colors.cyan)),
      Interest("Cooking", Icon(Icons.cookie_outlined, color: Colors.cyan)),
      Interest("Gym", Icon(Icons.sports_gymnastics_outlined, color: Colors.cyan)),
      Interest("Travel", Icon(Icons.travel_explore_outlined, color: Colors.cyan)),
      Interest("Cars", Icon(Icons.car_rental_outlined, color: Colors.cyan)),
    ];
}