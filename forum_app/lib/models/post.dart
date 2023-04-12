import 'package:forum_app/models/comment.dart';

class Post {
  String? username;
  int? interestsId;
  String? title;
  String? text;
  DateTime? createPost;
  List<Comment>? comments;
  List<String>? likes;

  Post({this.username, this.title, this.text, this.interestsId, this.createPost, this.comments, this.likes});
}

List<Post> listPosts = [
  Post(
    username: "Username",
    title: "скейтеры что самое тупое вам говорили люди (апвоут)",
    text: "Something text",
    comments: null,
    createPost: null,
    likes: null,
  ),
  Post(
    username: "Username2",
    title: "Что вы в детстве делали с животными и считали это смешным, а сейчас вы думаете что вы были живодёрами",
    text: "",
    comments: null,
    createPost: null,
    likes: null,
  ),
  Post(
    username: "Username",
    title: "Я ребенок выросший домашним насилием и на моих глазах мою сестру купали в любви пока меня били ногами или же деревянными палками по ногам задавайте вопросы",
    text: "да да я существую",
    comments: null,
    createPost: null,
    likes: null,
  ),
  Post(
    username: "Username4",
    title: "cool cool cool cool cool",
    text: "",
    comments: null,
    createPost: null,
    likes: null,
  ),
];