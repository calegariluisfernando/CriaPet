class User {
  int? id;
  String name;
  String apelido;
  String email;
  String password;
  String? avatar;

  User({
    this.id,
    required this.name,
    required this.email,
    this.apelido = '',
    this.password = '',
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
      name: json['name'],
      email: json['email'],
    );

    user.id = json['id'] ??= 0;
    user.apelido = json['apelido'] ??= '';
    user.password = json['password'] ??= '';

    return user;
  }
}
