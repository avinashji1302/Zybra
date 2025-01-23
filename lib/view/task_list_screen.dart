import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manangment/model/task_model.dart';
import 'package:manangment/view/add_task_screen.dart';
import 'package:manangment/viewmodel/task_view_model.dart';

import '../Constants/app_color.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Manager',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks available.'))
          : Container(
        color: AppColors.lightGrey,
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(
                task.title,
                style: const TextStyle(fontSize: 25),
              ),
              subtitle: Text(
                task.description,
                style: const TextStyle(fontSize: 15),
              ),
              trailing: Checkbox(
                value: task.isComplete,
                onChanged: (value) {
                  final updatedTask = TaskModel(
                    id: task.id,
                    title: task.title,
                    description: task.description,
                    isComplete: value ?? false,
                  );
                  ref
                      .read(taskViewModelProvider.notifier)
                      .updateTask(updatedTask);
                },
              ),
              onLongPress: () {
                // Show dialog with edit and delete options
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Center(
                      child: Text(
                        'Edit or Delete',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(color: AppColors.black, thickness: 2),
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit'),
                          onTap: () {
                            Navigator.pop(context); // Close the dialog
                            _showEditDialog(context, ref, task);
                          },
                        ),
                        const Divider(color: AppColors.black),
                        ListTile(
                          leading:
                          const Icon(Icons.delete, color: AppColors.red),
                          title: const Text('Delete'),
                          onTap: () {
                            Navigator.pop(context); // Close the dialog
                            ref
                                .read(taskViewModelProvider.notifier)
                                .deleteTask(task.id!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child:const Icon(Icons.add ,color:  AppColors.white),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  // Show the edit dialog
  void _showEditDialog(BuildContext context, WidgetRef ref, TaskModel task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            'Edit Task',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updatedTask = TaskModel(
                id: task.id,
                title: titleController.text,
                description: descriptionController.text,
              );

              ref.read(taskViewModelProvider.notifier).updateTask(updatedTask);
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
