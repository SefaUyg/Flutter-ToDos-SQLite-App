import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/todo_database.dart';
import '../data/todo_model.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  final ToDoDatabase database;

  ToDoBloc({required this.database}) : super(ToDoInitial()) {
    on<LoadToDos>((event, emit) async {
      emit(ToDoLoading());
      try {
        final todos = await database.readAllToDos();
        emit(ToDoLoaded(todos));
      } catch (e) {
        emit(ToDoError("Veriler yüklenemedi"));
      }
    });

    on<AddToDo>((event, emit) async {
      await database.create(ToDo(name: event.name));
      add(LoadToDos());
    });

    on<UpdateToDo>((event, emit) async {
      await database.update(event.todo);
      add(LoadToDos());
    });

    on<DeleteToDo>((event, emit) async {
      await database.delete(event.id);
      add(LoadToDos());
    });

    on<SearchToDos>((event, emit) async {
      emit(ToDoLoading());
      try {
        final results = await database.searchToDos(event.keyword);
        emit(ToDoLoaded(results));
      } catch (e) {
        emit(ToDoError("Arama yapılamadı"));
      }
    });
  }
}