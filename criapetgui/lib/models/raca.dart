class Raca {
  int? id;
  String name;

  Raca({this.id, required this.name});

  factory Raca.fromMap(Map<String, dynamic> map) => Raca(
    id: map['id'] as int? ?? 0,
    name: map['nome'] as String? ?? '',
  );
}