import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'data/todo_database.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => ToDoBloc(database: ToDoDatabase.instance)..add(LoadToDos()),
      child: ToDosApp(),
    ),
  );
}
class ToDosApp extends StatelessWidget {
  const ToDosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      title: 'ToDos App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
