import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_bloc/todo_bloc.dart';
import 'data/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController search = TextEditingController();

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

  pinTodo(int index) {
    context.read<TodoBloc>().add(
          PinTodo(index),
        );
  }

  void handlePopupClick(String value) {
    switch (value) {
      case 'Выполнить все':
        List<Todo> todos = context.read<TodoBloc>().state.todos;
        for (int i = 0; i < todos.length; i++) {
          if (!todos[i].isDone) alterTodo(i);
        }
        break;
      case 'Отменить все':
        List<Todo> todos = context.read<TodoBloc>().state.todos;
        for (int i = 0; i < todos.length; i++) {
          if (todos[i].isDone) alterTodo(i);
        }
        break;
      case 'Удалить все':
        context
            .read<TodoBloc>()
            .state
            .todos
            .forEach((todo) => removeTodo(todo));
        break;
      case 'Открепить все':
        List<Todo> todos = context.read<TodoBloc>().state.todos;
        for (int i = 0; i < todos.length; i++) {
          if (todos[i].isPinned) pinTodo(i);
        }
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
        actions: [
          PopupMenuButton<String>(
            onSelected: handlePopupClick,
            itemBuilder: (BuildContext context) {
              return {
                'Выполнить все',
                'Отменить все',
                'Удалить все',
                'Открепить все'
              }.map((String choice) {
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
        padding: EdgeInsets.all(calculateSize() / 20),
        child: Column(
          children: [
            const SizedBox(height: 15),
            buildSearchBar(controller: search),
            const SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  if (state.status == TodoStatus.success) {
                    return buildListViewTodos(
                        state: state, context: context);
                  } else if (state.status == TodoStatus.initial) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
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

  double calculateSize() {
    double width = MediaQuery.of(context).size.width;
    int length = context.read<TodoBloc>().state.todos.length;
    bool oneLine = length * 300 < width;
    return oneLine && length != 0 ? width / length : 300;
  }

  Widget buildListViewTodos(
      {required TodoState state,
      required BuildContext context}) {
    
    state.todos.sort((a, b) => (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0));

    final todosToDisplay = state.todos
        .where((x) => x.title.contains(search.text) || x.subtitle.contains(search.text))
        .toList();

    final todosToDisplayCopy = List.from(todosToDisplay);

    todosToDisplay.sort((a, b) => b.isPinned.toString().compareTo(a.isPinned.toString()));
    var size = calculateSize();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: size,
        crossAxisSpacing: size / 20,
        mainAxisSpacing: size / 20,
      ),
      itemCount: todosToDisplayCopy.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, int i) {
        return buildListTile(
          todo: todosToDisplayCopy[i],
          context: context,
          index: i,
        );
      },
    );
  }

  Widget buildSearchBar({required TextEditingController controller}) {
    return TextField(
      cursorColor: Colors.black54,
      controller: controller,
      onChanged: (value) => {setState(() => ())},
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.search),
        hintText: 'Поиск',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.all(Radius.circular(calculateSize() / 20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.all(Radius.circular(calculateSize() / 20)),
        ),
      ),
    );
  }

  Widget buildSliderRemove() {
    return Container(
      padding: EdgeInsets.only(left: calculateSize() / 20),
      alignment: Alignment.centerLeft,
      color: Colors.red,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            'Удалить',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSliderCancel() {
    return Container(
      padding: EdgeInsets.only(right: calculateSize() / 20),
      alignment: Alignment.centerRight,
      color: Theme.of(context).colorScheme.primary,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cancel,
            color: Colors.white,
          ),
          Text(
            'Отменить',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSliderMake() {
    return Container(
      padding: EdgeInsets.only(right: calculateSize() / 20),
      alignment: Alignment.centerRight,
      color: Colors.green,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            color: Colors.white,
          ),
          Text(
            'Выполнить',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void deletePinned(Todo todo) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить заметку?'),
          content: const Text('Вы действительно хотите удалить заметку?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
    if (confirm != null && confirm) {
      removeTodo(todo);
    } else
      setState(() => ());
  }

  Widget buildListTile({
    required Todo todo,
    required BuildContext context,
    required int index,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => alertDialog('Изменить задачу', todo.title, todo.subtitle,
          buildTextSaveButton, index),
      onDoubleTap: () => pinTodo(index),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: todo.isDone
              ? Colors.green
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(calculateSize() / 20),
        ),
        child: Dismissible(
          background: buildSliderRemove(),
          secondaryBackground:
              todo.isDone ? buildSliderCancel() : buildSliderMake(),
          key: UniqueKey(),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              alterTodo(index);
            } else if (direction == DismissDirection.startToEnd) {
              if (todo.isPinned) {
                deletePinned(todo);
              } else {
                removeTodo(todo);
              }
            }
          },
          child: ListTile(
            trailing: todo.isPinned
                ? const Icon(Icons.push_pin_rounded, color: Colors.white)
                : null,
            title: Text(
              todo.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              todo.subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
