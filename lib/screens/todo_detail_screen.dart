import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/local_storage.dart';

class TodoDetailScreen extends StatefulWidget {
  const TodoDetailScreen({super.key});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isEdit = false;
  int? editIndex;

  late String username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      username = args['username'];
      if (args.containsKey('todo')) {
        final todo = args['todo'] as TodoModel;
        _titleController.text = todo.title;
        _descController.text = todo.description;
        selectedDate = todo.dateTime;
        selectedTime = TimeOfDay.fromDateTime(todo.dateTime);
        isEdit = true;
        editIndex = args['index'];
      }
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> _save() async {
    if (_titleController.text.isEmpty || selectedDate == null || selectedTime == null) return;

    final dateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final newTodo = TodoModel(
      title: _titleController.text,
      description: _descController.text,
      dateTime: dateTime,
    );

    final todos = await LocalStorageService.loadTodos(username);
    if (isEdit && editIndex != null) {
      todos[editIndex!] = newTodo;
    } else {
      todos.add(newTodo);
    }

    await LocalStorageService.saveTodos(username, todos);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit ToDo" : "Add ToDo")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Your ToDo')),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(selectedDate == null
                      ? "Select Date"
                      : "${selectedDate!.toLocal()}".split(' ')[0]),
                ),
                ElevatedButton(onPressed: _pickDate, child: const Text("Pick Date")),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(selectedTime == null
                      ? "Select Time"
                      : selectedTime!.format(context)),
                ),
                ElevatedButton(onPressed: _pickTime, child: const Text("Pick Time")),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: Text(isEdit ? "Save" : "Add New")),
          ],
        ),
      ),
    );
  }
}
