import '../data/todo_model.dart';

abstract class ToDoEvent {}

class LoadToDos extends ToDoEvent {}

class AddToDo extends ToDoEvent {
  final String name;
  AddToDo(this.name);
}

class UpdateToDo extends ToDoEvent {
  final ToDo todo;
  UpdateToDo(this.todo);
}

class DeleteToDo extends ToDoEvent {
  final int id;
  DeleteToDo(this.id);
}

class SearchToDos extends ToDoEvent {
  final String keyword;
  SearchToDos(this.keyword);
}