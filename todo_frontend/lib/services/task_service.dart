import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskService extends ChangeNotifier {
  final String apiUrl = "http://127.0.0.1:8000/api/tasks";

  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Task.fromJson(item)).toList();
    } else {
      throw "Failed to load tasks";
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode == 201) {
      notifyListeners(); // Notifier les écouteurs après la création
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to create task";
    }
  }

  Future<Task> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode == 200) {
      notifyListeners(); // Notifier les écouteurs après la mise à jour
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to update task";
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 204) {
      notifyListeners(); // Notifier les écouteurs après la suppression
    } else {
      throw "Failed to delete task";
    }
  }
}