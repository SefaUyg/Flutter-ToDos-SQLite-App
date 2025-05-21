import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../data/todo_model.dart';

class DetailPage extends StatefulWidget {
  final int todoId;
  final String initialName;

  const DetailPage({super.key, required this.todoId, required this.initialName});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _updateToDo() {
    final updatedName = nameController.text.trim();

    if (updatedName.isNotEmpty) {
      final updatedToDo = ToDo(id: widget.todoId, name: updatedName);

      context.read<ToDoBloc>().add(UpdateToDo(updatedToDo));

      // Geri dön
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Görev adı boş olamaz")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Görev Detayı"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Görev"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateToDo,
              child: const Text("Güncelle"),
            ),
          ],
        ),
      ),
    );
  }
}