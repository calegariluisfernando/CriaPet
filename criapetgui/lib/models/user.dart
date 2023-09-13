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
      id: map['id'] as int? ?? 0,
      uuid: map['uuid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      apelido: map['apelido'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
      photoUrl: map['photo_url'] as String? ?? '',
      token: map['token'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'apelido': apelido,
      'email': email,
      'password': password,
      'photo_url': photoUrl,
      'token': token,
    };
  }
}
