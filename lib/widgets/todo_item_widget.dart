import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onTap;

  const TodoItemWidget({super.key, required this.todo, required this.onTap});

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    
    if (taskDate == today) {
      return 'Today at $timeStr';
    } else if (taskDate == tomorrow) {
      return 'Tomorrow at $timeStr';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at $timeStr';
    }
  }

  Color _getPriorityColor() {
    final now = DateTime.now();
    final difference = todo.dateTime.difference(now).inHours;
    
    if (difference < 0) {
      return Colors.red; // Overdue
    } else if (difference < 24) {
      return Colors.orange; // Due soon
    } else {
      return const Color(0xFF6A4C93); // Normal
    }
  }

  IconData _getPriorityIcon() {
    final now = DateTime.now();
    final difference = todo.dateTime.difference(now).inHours;
    
    if (difference < 0) {
      return Icons.warning;
    } else if (difference < 24) {
      return Icons.schedule;
    } else {
      return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: todo.isCompleted ? Colors.green : priorityColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Status Icon
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: todo.isCompleted ? Colors.green : priorityColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    todo.isCompleted ? Icons.check : _getPriorityIcon(),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Task Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: todo.isCompleted ? Colors.grey : const Color(0xFF2D2D2D),
                          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (todo.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: todo.isCompleted ? Colors.grey : Colors.grey[600],
                            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: priorityColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateTime(todo.dateTime),
                            style: TextStyle(
                              fontSize: 12,
                              color: priorityColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Action Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A4C93).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF6A4C93),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}