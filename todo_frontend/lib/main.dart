import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'services/task_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoList', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Task>>(
        future: Provider.of<TaskService>(context, listen: false).getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else {
            List<Task> tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                Task task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    title: Text(task.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(task.description ?? '', style: TextStyle(fontSize: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _editTask(context, task);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await Provider.of<TaskService>(context, listen: false)
                                .deleteTask(task.id!);
                            // Rafraîchir la liste après suppression
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('addTaskButton'),
        onPressed: () {
          _addTask(context);
        },
        backgroundColor: Colors.blueAccent,
        tooltip: 'Ajouter une tâche',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addTask(BuildContext context) async {
    final taskService = Provider.of<TaskService>(context, listen: false);
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter une Tâche', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titre', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                Task newTask = Task(
                  title: titleController.text,
                  description: descriptionController.text,
                );
                await taskService.createTask(newTask);
                Navigator.pop(context);
              },
              child: const Text('Ajouter', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _editTask(BuildContext context, Task task) async {
    final taskService = Provider.of<TaskService>(context, listen: false);
    TextEditingController titleController = TextEditingController(text: task.title);
    TextEditingController descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier la Tâche', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titre', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                Task updatedTask = Task(
                  id: task.id,
                  title: titleController.text,
                  description: descriptionController.text,
                );
                await taskService.updateTask(updatedTask);
                Navigator.pop(context);
              },
              child: const Text('Enregistrer', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}