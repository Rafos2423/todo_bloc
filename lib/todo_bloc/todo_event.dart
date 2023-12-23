part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class TodoStarted extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;

  const AddTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

class RemoveTodo extends TodoEvent {
  final Todo todo;

  const RemoveTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

class AlterTodo extends TodoEvent {
  final int index;

  const AlterTodo(this.index);

  @override
  List<Object?> get props => [index];
}

class EditTodo extends TodoEvent {
  final int index;
  final Todo todo;

  const EditTodo(this.todo, this.index);

  @override
  List<Object?> get props => [index, todo];
}

class PinTodo extends TodoEvent {
  final int index;

  const PinTodo(this.index);

  @override
  List<Object?> get props => [index];
}
