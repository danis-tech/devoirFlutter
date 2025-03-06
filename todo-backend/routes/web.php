<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Api\TaskController;

// Routes API pour les tâches
Route::prefix('api')->group(function () {
    Route::apiResource('tasks', TaskController::class);
});

Route::get('/', function () {
    return view('welcome');
});
