import 'package:forum_app/models/comment.dart';

class Post {
  String? Username;
  int? InterestsId;
  String? Text;
  DateTime? CreatePost;
  List<Comment>? comments;
  List<String>? likes; 
}