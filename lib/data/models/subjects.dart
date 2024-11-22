class Subjects {
  final int id;
  final String title;
  final String description;
  final String image;

  const Subjects(
      {required this.id,
      required this.title,
      required this.description,
      required this.image});

  factory Subjects.fromJson(Map<String, dynamic> json) {
    return Subjects(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        image: json['image']);
  }
}
