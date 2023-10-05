class Especie {
  int? id;
  String name;

  Especie({this.id, required this.name});

  factory Especie.fromMap(Map<String, dynamic> map) => Especie(
    id: map['id'] as int? ?? 0,
    name: map['name'] as String? ?? '',
  );
}