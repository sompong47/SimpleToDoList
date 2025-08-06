import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';
import '../services/local_storage.dart';
import '../widgets/todo_item_widget.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  String username = '';
  List<TodoModel> todos = [];

  @override
  void initState() {
    super.initState();
    _loadUserAndTodos();
  }

  Future<void> _loadUserAndTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('username') ?? '';
    final list = await LocalStorageService.loadTodos(user);
    setState(() {
      username = user;
      todos = list;
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    Navigator.pushReplacementNamed(context, '/');
  }

  void _goToAddTodo() async {
    final result = await Navigator.pushNamed(context, '/add_todo', arguments: {
      'username': username,
    });
    if (result == true) {
      _loadUserAndTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My ToDo List"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: todos.isEmpty
          ? const Center(child: Text("No tasks yet"))
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return TodoItemWidget(
                  todo: todo,
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/add_todo',
                      arguments: {
                        'username': username,
                        'todo': todo,
                        'index': index,
                      },
                    );
                    if (result == true) {
                      _loadUserAndTodos();
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
