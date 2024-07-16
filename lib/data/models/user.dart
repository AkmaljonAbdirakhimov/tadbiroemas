class User {
  final String id;
  String email;
  String token;
  DateTime expiresIn;

  User({
    required this.id,
    required this.email,
    required this.token,
    required this.expiresIn,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['localId'],
      email: json['email'],
      token: json['idToken'],
      expiresIn: DateTime.now().add(
        Duration(
          seconds: int.parse(
            json['expiresIn'],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "localId": id,
      "email": email,
      "idToken": token,
      "expiresIn": expiresIn.toString(),
    };
  }
}
