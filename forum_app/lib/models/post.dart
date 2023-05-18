import 'package:forum_app/models/comment.dart';

class Post {
  String? id;
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
    this.likes,
    this.id}
  );

  factory Post.fromMap(Map<dynamic, dynamic> map) {
    List<Comment> comments = [];
    List<String> likes = [];

    if (map['comments'] != "null" && map['comments'] != null)
    {
      ((map['comments'] ?? [] as Map<dynamic, dynamic>)).forEach((key, value) {
        var commentValue = value as Map<dynamic, dynamic>;
        final comment = Comment((commentValue)['username'],
          (commentValue)['text'] ?? '', 
          DateTime.parse((commentValue)['createdDate'] ?? DateTime.now().toString()));
        comments.add(comment); 
      });
    }

    if (map['likes'] != "null" && map['likes'] != null)
    {
      map['likes'].forEach((obj) {likes.add(obj.toString());});
    }

    comments.sort(((a, b) => a.createdDate!.compareTo(b.createdDate!)));

    return Post(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      title: map['title'] ?? '',
      text: map['text'] ?? '',
      imgUrl: map['imgUrl'] ?? 'null',
      interestsId: map['interestsId'] != null ? int.parse(map['interestsId']) : 0,
      createPost: map['createPost'] != null && map['createPost'] != 'null' ? DateTime.parse(map['createPost']) : DateTime.now(),
      comments: map['comments'] == "null" || map['comments'] == null ? null : comments,
      likes: map['likes'] == "null" || map['likes'] == null ? null : likes,
    );
  }
}