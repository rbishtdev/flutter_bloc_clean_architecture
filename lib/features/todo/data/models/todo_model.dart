import '../../domain/entities/todo.dart';

class TodoModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;
  final bool isSynced;
  final bool isDeleted;

  const TodoModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
    required this.isSynced,
    required this.isDeleted,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
    userId: json['userId'],
    id: json['id'],
    title: json['title'],
    completed: json['completed'] == 1 || json['completed'] == true,
    isSynced: json['is_synced'] == 1,
    isDeleted: json['is_deleted'] == 1,
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'id': id,
    'title': title,
    'completed': completed ? 1 : 0,
    'is_synced': isSynced ? 1 : 0,
    'is_deleted': isDeleted ? 1 : 0,
  };

  Todo toEntity() => Todo(
    userId: userId,
    id: id,
    title: title,
    completed: completed,
  );

  static TodoModel fromEntity(
      Todo todo, {
        bool isSynced = true,
        bool isDeleted = false,
      }) {
    return TodoModel(
      userId: todo.userId,
      id: todo.id,
      title: todo.title,
      completed: todo.completed,
      isSynced: isSynced,
      isDeleted: isDeleted,
    );
  }

  TodoModel copyWith({
    int? userId,
    int? id,
    String? title,
    bool? completed,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return TodoModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
