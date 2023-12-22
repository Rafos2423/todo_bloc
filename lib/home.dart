import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'todo_bloc/todo_bloc.dart';
import 'data/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  addTodo(Todo todo) {
    context.read<TodoBloc>().add(
          AddTodo(todo),
        );
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(
          RemoveTodo(todo),
        );
  }

  editTodo(Todo todo, int index) {
    context.read<TodoBloc>().add(
          EditTodo(todo, index),
        );
  }

  alterTodo(int index) {
    context.read<TodoBloc>().add(AlterTodo(index));
  }

  void handlePopupClick(String value) {
    switch (value) {
      case 'Выполнить все':
        List<Todo> todos = context
            .read<TodoBloc>()
            .state
            .todos
            .where((todo) => !todo.isDone)
            .toList();
        for (int i = 0; i < todos.length; i++) {
          alterTodo(i);
        }
        break;
      case 'Отменить все':
        List<Todo> todos = context
            .read<TodoBloc>()
            .state
            .todos
            .where((todo) => todo.isDone)
            .toList();
        for (int i = 0; i < todos.length; i++) {
          alterTodo(i);
        }
        break;
      case 'Удалить все':
        context
            .read<TodoBloc>()
            .state
            .todos
            .forEach((todo) => removeTodo(todo));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => alertDialog(
            'Добавить задачу', null, null, buildTextAddButton, null),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: const Text(
          'Список дел',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handlePopupClick,
            itemBuilder: (BuildContext context) {
              return {'Выполнить все', 'Отменить все', 'Удалить все'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.success) {
              return buildListViewTodos(state: state, context: context);
            } else if (state.status == TodoStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void alertDialog(String label, String? title, String? desc, Function function,
      int? index) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller1 = TextEditingController(text: title);
        TextEditingController controller2 = TextEditingController(text: desc);

        return AlertDialog(
          title: Text(label),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField(
                  controller: controller1,
                  hintText: 'Заголовок',
                  context: context),
              const SizedBox(height: 10),
              buildTextField(
                  controller: controller2,
                  hintText: 'Описание',
                  context: context),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: function(
                  controller1: controller1,
                  controller2: controller2,
                  context: context,
                  index: index),
            )
          ],
        );
      },
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required BuildContext context,
  }) {
    return TextField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.secondary,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget buildTextAddButton({
    required TextEditingController controller1,
    required TextEditingController controller2,
    required BuildContext context,
    int? index,
  }) {
    return TextButton(
      onPressed: () {
        addTodo(
          Todo(
            title: controller1.text,
            subtitle: controller2.text,
          ),
        );
        controller1.text = '';
        controller2.text = '';
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Icon(
          CupertinoIcons.check_mark,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget buildTextSaveButton(
      {required TextEditingController controller1,
      required TextEditingController controller2,
      required BuildContext context,
      required int index}) {
    return TextButton(
      onPressed: () {
        editTodo(
            Todo(
              title: controller1.text,
              subtitle: controller2.text,
            ),
            index);
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Icon(
          CupertinoIcons.check_mark,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget buildListViewTodos({
    required TodoState state,
    required BuildContext context,
  }) {
    return ListView.builder(
      itemCount: state.todos.length,
      itemBuilder: (context, int i) {
        return buildListTile(
          todo: state.todos[i],
          context: context,
          index: i,
        );
      },
    );
  }

  Widget buildSliderRemove(Todo todo) {
    return SlidableAction(
      onPressed: (_) {
        removeTodo(todo);
      },
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: 'Удалить',
    );
  }

  SlidableAction buildSliderCancel(int index) {
    return SlidableAction(
      onPressed: (_) {
        alterTodo(index);
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      icon: Icons.cancel,
      label: 'Отменить',
    );
  }

  SlidableAction buildSliderMake(int index) {
    return SlidableAction(
      onPressed: (_) {
        alterTodo(index);
      },
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      icon: Icons.check,
      label: 'Выполнить',
    );
  }

  Widget buildListTile({
    required Todo todo,
    required BuildContext context,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => alertDialog('Изменить задачу', todo.title, todo.subtitle,
          buildTextSaveButton, index),
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Card(
          color: todo.isDone
              ? Colors.green
              : Theme.of(context).colorScheme.primary,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Slidable(
            key: const ValueKey(0),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.3,
              openThreshold: 0.3,
              closeThreshold: 0.3,
              children: [buildSliderRemove(todo)],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.3,
              openThreshold: 0.3,
              closeThreshold: 0.3,
              children: [
                if (todo.isDone)
                  buildSliderCancel(index)
                else
                  buildSliderMake(index),
              ],
            ),
            child: ListTile(
              title: Text(todo.title),
              subtitle: Text(todo.subtitle),
            ),
          ),
        ),
      ),
    );
  }
}
