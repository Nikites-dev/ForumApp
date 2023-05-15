import 'package:forum_app/models/user_info.dart';

class Comment {
  String? username;
  String? text;
  DateTime? createdDate;
  UserInfo? userInfo;

  Comment(this.username, this.text, this.createdDate);
}