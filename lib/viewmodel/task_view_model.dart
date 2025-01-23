import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manangment/model/task_model.dart';
import 'package:manangment/service/service_db.dart';

class TaskViewModel extends StateNotifier<List<TaskModel>> {
  TaskViewModel() : super([]) {
    loadTasks(); // Load tasks when the ViewModel is created
  }

  final DBService _dbService = DBService.instance;

  // Fetch tasks from the database
  Future<void> loadTasks() async {
    final tasks = await _dbService.fetchTasks();
    state = tasks; // Update the state with the fetched tasks
  }

  // Add a new task
  Future<void> addTask(TaskModel task) async {
    await _dbService.insertTask(task);
    loadTasks(); // Reload tasks to reflect the changes
  }

  // Update an existing task
  Future<void> updateTask(TaskModel task) async {
    await _dbService.updateTask(task);
    loadTasks(); // Reload tasks to reflect the changes
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    await _dbService.deleteTask(id);
    loadTasks(); // Reload tasks to reflect the changes
  }
}

// Define a provider for TaskViewModel
final taskViewModelProvider =
    StateNotifierProvider<TaskViewModel, List<TaskModel>>((ref) {
  return TaskViewModel();
});
