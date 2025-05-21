import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../data/todo_database.dart';
import 'detail_page.dart';
import 'save_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoBloc(database: ToDoDatabase.instance)..add(LoadToDos()),
      child: const ToDoView(),
    );
  }
}

class ToDoView extends StatefulWidget {
  const ToDoView({super.key});

  @override
  State<ToDoView> createState() => _ToDoViewState();
}

class _ToDoViewState extends State<ToDoView> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoBloc = BlocProvider.of<ToDoBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDos"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Ara",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  todoBloc.add(LoadToDos());
                } else {
                  todoBloc.add(SearchToDos(value));
                }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ToDoBloc, ToDoState>(
              builder: (context, state) {
                if (state is ToDoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ToDoLoaded) {
                  final todos = state.todos;

                  if (todos.isEmpty) {
                    return const Center(child: Text("Henüz görev eklenmedi."));
                  }

                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];

                      return ListTile(
                        title: Text(todo.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            todoBloc.add(DeleteToDo(todo.id!));
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(
                                todoId: todo.id!,
                                initialName: todo.name,
                              ),
                            ),
                          ).then((_) => todoBloc.add(LoadToDos()));
                        },
                      );
                    },
                  );
                } else if (state is ToDoError) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SavePage()),
          ).then((_) => todoBloc.add(LoadToDos()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}