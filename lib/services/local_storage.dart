import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

class LocalStorageService {
  static const _keyPrefix = "todos_";

  static Future<List<TodoModel>> loadTodos(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyPrefix + username);
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => TodoModel.fromJson(e)).toList();
  }

  static Future<void> saveTodos(String username, List<TodoModel> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(todos.map((e) => e.toJson()).toList());
    await prefs.setString(_keyPrefix + username, encoded);
  }
}
