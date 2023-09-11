class User {
  int? id;
  String? uuid;
  String? name;
  String? apelido;
  String? email;
  String? password;
  String? photoUrl;
  String? token;

  User({
    this.id,
    this.uuid,
    this.name,
    this.apelido,
    this.email,
    this.password,
    this.photoUrl,
    this.token,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ? map['id'] : null,
      uuid: map['uuid'] ? map['uuid'] : null,
      name: map['name'] ? map['name'] : null,
      apelido: map['apelido'] ? map['apelido'] : null,
      email: map['email'] ? map['email'] : null,
      password: map['password'] ? map['password'] : null,
      photoUrl: map['photo_url'] ? map['photo_url'] : null,
      token: map['token'] ? map['token'] : null,
    );
  }
}
