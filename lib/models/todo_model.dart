class TodoModel {
  String title;
  String description;
  DateTime dateTime;
  bool isCompleted;

  TodoModel({
    required this.title,
    required this.description,
    required this.dateTime,
    this.isCompleted = false,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'dateTime': dateTime.toIso8601String(),
        'isCompleted': isCompleted,
      };
}
