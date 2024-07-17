class User {
  final String id;
  String email;
  String token;
  String refreshToken;
  DateTime expiresIn;

  User({
    required this.id,
    required this.email,
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['localId'],
      email: json['email'],
      token: json['idToken'],
      refreshToken: json['refreshToken'],
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
      "refreshToken": refreshToken,
      "expiresIn": expiresIn.toString(),
    };
  }
}
