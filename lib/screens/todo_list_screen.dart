import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // เพิ่มบรรทัดนี้
import '../models/todo_model.dart';
import '../services/local_storage.dart';
import '../services/auth_service.dart';
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
    final currentUser = await AuthService.getCurrentUser();
    if (currentUser != null) {
      final list = await LocalStorageService.loadTodos(currentUser.username);
      setState(() {
        username = currentUser.username;
        todos = list;
      });
    }
  }

  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF6A4C93))),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('username');
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
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
    final completedTasks = todos.where((todo) => todo.isCompleted).length;
    final totalTasks = todos.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A4C93),
              Color(0xFFF8F7FF),
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: Text(
                        username.isNotEmpty ? username[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: Color(0xFF6A4C93),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello,',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                      iconSize: 28,
                    ),
                  ],
                ),
              ),

              // Progress Card
              if (totalTasks > 0)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6A4C93), Color(0xFF8B5CF6)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${(completedTasks / totalTasks * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Task Progress',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6A4C93),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$completedTasks of $totalTasks tasks completed',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Task List
              Expanded(
                child: todos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.task_alt,
                                size: 60,
                                color: Color(0xFF6A4C93),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'No tasks yet',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6A4C93),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Add your first task to get started',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: todos.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddTodo,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}