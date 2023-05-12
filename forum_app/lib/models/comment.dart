class Comment {
  String? username;
  String? text;

  Comment(this.username, this.text);

  factory Comment.fromMap(Map<dynamic, dynamic> map) {
    return Comment(
      map['username'] ?? '',
      map['text'] ?? ''
    );
  }
}