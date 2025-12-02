class TodoItem {
  int? id;
  String title;
  String? description;
  String? category;
  DateTime? dueDate;
  String? priority;
  bool isDone;

  TodoItem({
    this.id,
    required this.title,
    this.description,
    this.category,
    this.dueDate,
    this.priority,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: map['priority'],
      isDone: map['isDone'] == 1,
    );
  }
}
