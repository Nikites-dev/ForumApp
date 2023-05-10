import 'package:forum_app/models/comment.dart';

class Post {
  String? username;
  int? interestsId;
  String? title;
  String? text;
  String? imgUrl;
  DateTime? createPost;
  List<Comment>? comments;
  List<String>? likes;

  Post(
      {this.username,
      this.title,
      this.text,
      this.imgUrl,
      this.interestsId,
      this.createPost,
      this.comments,
      this.likes});

  factory Post.fromMap(Map<dynamic, dynamic> map) {
    return Post(
      username: map['username'] ?? '',
      title: map['title'] ?? '',
      text: map['text'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      interestsId: int.parse(map['interestsId']?? '') ,
      createPost: DateTime.parse(map['createPost'] ?? ''),
      comments: map['comments'] == "null" ? null:map['comments'],
      likes: map['likes'] == "null" ? null:map['likes'],
    );
  }
}



List<Post> listPosts = [
  Post(
    username: "Username",
    title: "скейтеры что самое тупое вам говорили люди (апвоут)",
    text:
        "Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  Something text... Long text...  ",
    comments: null,
    createPost: null,
    likes: null,
    imgUrl: null,
  ),
  Post(
    username: "Username2",
    title:
        "Что вы в детстве делали с животными и считали это смешным, а сейчас вы думаете что вы были живодёрами",
    text: "просто был личный опыт :/",
    comments: null,
    createPost: null,
    likes: null,
    imgUrl: 'https://patentus.ru/blog/wp-content/uploads/2021/10/1-2.jpg',
  ),
  Post(
    username: "Username",
    title:
        "Я ребенок выросший домашним насилием и на моих глазах мою сестру купали в любви пока меня били ногами или же деревянными палками по ногам задавайте вопросы",
    text: "да да я существую",
    comments: null,
    createPost: null,
    likes: null,
    imgUrl: null,
  ),
  Post(
    username: "Username4",
    title: "cool cool cool cool cool",
    text: "",
    comments: null,
    createPost: null,
    likes: null,
    imgUrl:
        'https://images.unsplash.com/photo-1679764376519-807d8b7ea416?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxODY2Nzh8MHwxfHJhbmRvbXx8fHx8fHx8fDE2ODE2MzI3OTM&ixlib=rb-4.0.3&q=80&w=1080',
  ),
];



