
class User {
  String? username;
  String? email;
  String? password;
  String? image;
  List<int>? interests;

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
    List<int> interests = [];

    if (value['interests'] != null)
    {
      (value['interests']).forEach((interest) {
        interests.add(int.parse(interest.toString()));
      });
    }

    return User(
      username: value['username'],
      email: value['email'],
      password: value['password'],
      image: value['image'],
      interests: interests,
    );
  }

  @override
  String toString() {
    return ('{Username: $username, Email: $email, Password: $password}');
  }
}