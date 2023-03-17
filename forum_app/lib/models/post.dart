import 'package:forum_app/models/comment.dart';

class Post {
  int? UserId;
  int? InterestsId;
  String? Text;
  DateTime? CreatePost;
  List<Comment>? comments;
  List<String>? likes; 
}