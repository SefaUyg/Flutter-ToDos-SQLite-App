class ToDo {
  final int? id;
  final String name;

  ToDo({
    this.id,
    required this.name
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      name: map['name'],
    );
  }
}