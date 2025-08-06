import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onTap;

  const TodoItemWidget({super.key, required this.todo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      subtitle: Text("${todo.dateTime.toLocal()}"),
      trailing: Icon(todo.isCompleted ? Icons.check_circle : Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
