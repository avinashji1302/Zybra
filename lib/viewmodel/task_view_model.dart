import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manangment/model/task_model.dart';
import 'package:manangment/service/service_db.dart';

class TaskViewModel extends StateNotifier<List<TaskModel>> {
  TaskViewModel() : super([]) {
    loadTasks(); 
  }

  final DBService _dbService = DBService.instance;

  // Fetch tasks from the database
  Future<void> loadTasks() async {
    final tasks = await _dbService.fetchTasks();
    state = tasks; 
  }

  // Add a new task
  Future<void> addTask(TaskModel task) async {
    await _dbService.insertTask(task);
    loadTasks(); 
  }

  // Update an existing task
  Future<void> updateTask(TaskModel task) async {
    await _dbService.updateTask(task);
    loadTasks(); 
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    await _dbService.deleteTask(id);
    loadTasks(); 
  }
}

// Define a provider for TaskViewModel
final taskViewModelProvider =
    StateNotifierProvider<TaskViewModel, List<TaskModel>>((ref) {
  return TaskViewModel();
});
