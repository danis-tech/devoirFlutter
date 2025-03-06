<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Task;
class TaskController extends Controller
{
    // Lister toutes les tâches
    public function index()
    {
        return Task::all();
    }

    // Créer une nouvelle tâche
    public function store(Request $request)
    {
        $task = Task::create($request->all());
        return response()->json($task, 201);
    }

    // Afficher une tâche spécifique
    public function show(Task $task)
    {
        return $task;
    }

    // Mettre à jour une tâche
    public function update(Request $request, Task $task)
    {
        $task->update($request->all());
        return response()->json($task, 200);
    }

    // Supprimer une tâche
    public function destroy(Task $task)
    {
        $task->delete();
        return response()->json(null, 204);
    }
}