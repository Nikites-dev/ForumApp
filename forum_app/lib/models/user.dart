import 'package:forum_app/models/interest.dart';

class User {
  User({
    this.Username,
    this.Email,
    this.Password,
    this.Image,
    this.Interests,
  });

  String? Username;
  String? Email;
  String? Password;
  String? Image;
  List<Interest>? Interests;

  Map<String, Object> toMap() {
    return {
      'Username': Username!,
      'Email': Email!,
      'Password': Password!,
      'Image': Image!,
      'Interests': Interests!,
    };
  }


  static User? fromMap(Map<dynamic, dynamic> value) {
    if (value == null) {
      return null;
    }

    return User(
      Username: value['Username'],
      Email: value['Email'],
      Password: value['Password'],
      Image: value['Image'],
      Interests: value['Interests'],
    );
  }

  @override
  String toString() {
    return ('{Username: $Username, Email: $Email, Password: $Password}');
  }
}