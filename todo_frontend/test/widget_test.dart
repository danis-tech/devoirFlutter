import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_frontend/main.dart';
import 'package:todo_frontend/services/task_service.dart';

void main() {
  testWidgets('Add and delete task test', (WidgetTester tester) async {
    // Créer un mock de TaskService
    final taskService = TaskService();

    // Construire l'application avec le TaskService mocké
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => taskService),
        ],
        child: const MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    // Vérifier que la liste est vide au départ
    expect(find.byType(ListTile), findsNothing);

    // Simuler l'ajout d'une tâche
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pumpAndSettle();

    // Remplir le formulaire et ajouter une tâche
    await tester.enterText(find.byType(TextField).first, 'New Task');
    await tester.enterText(find.byType(TextField).last, 'Task Description');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Vérifier que la tâche a été ajoutée
    expect(find.byType(ListTile), findsOneWidget);

    // Simuler la suppression d'une tâche
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Vérifier que la tâche a été supprimée
    expect(find.byType(ListTile), findsNothing);
  });
}