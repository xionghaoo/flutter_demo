class Dog {
  final int id;
  final String name;
  final int age;

  Dog(this.id, this.name, this.age);

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "age": age
  };

  @override
  String toString() => "{id: $id, name: $name, age: $age}";
}