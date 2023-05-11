class Comment {
  String? Username;
  String? Text;

  Comment(this.Username, this.Text);

  factory Comment.fromMap(Map<dynamic, dynamic> map) {
    return Comment(
      map['username'] ?? '',
      map['text'] ?? ''
    );
  }
}