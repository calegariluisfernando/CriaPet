class User {
  int? id;
  String name;
  String apelido;
  String email;
  String password;
  String? avatar;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    required this.name,
    required this.email,
    this.apelido = '',
    this.password = '',
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
      name: json['name'],
      email: json['email'],
    );

    user.id = json['id'] ??= 0;
    user.apelido = json['apelido'] ??= '';
    user.password = json['password'] ??= '';

    user.createdAt = json['created_at'].toString().isNotEmpty
        ? DateTime.parse(json['created_at'])
        : DateTime.now();

    user.updatedAt = json['updated_at'].toString().isNotEmpty
        ? DateTime.parse(json['updated_at'])
        : DateTime.now();

    return user;
  }
}
