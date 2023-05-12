import 'package:forum_app/models/interest.dart';

class User {
  String? username;
  String? email;
  String? password;
  String? image;
  List<Interest>? interests;

  User({
    this.username,
    this.email,
    this.password,
    this.image,
    this.interests,
  });

  Map<String, Object> toMap() {
    return {
      'Username': username!,
      'Email': email!,
      'Password': password!,
      'Image': image!,
      'Interests': interests!,
    };
  }

  static User? fromMap(Map<dynamic, dynamic>? value) {
    if (value == null) {
      return null;
    }

    return User(
      username: value['Username'],
      email: value['Email'],
      password: value['Password'],
      image: value['Image'],
      interests: value['Interests'],
    );
  }

  @override
  String toString() {
    return ('{Username: $username, Email: $email, Password: $password}');
  }
}