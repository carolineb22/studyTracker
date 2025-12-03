import 'package:flutter/material.dart';
import 'package:final_project/widgets/listItem.dart';
import 'package:final_project/models/todo_item.dart';
import 'package:final_project/pages/detailPage.dart';

class UserTodo extends StatefulWidget {
  final List<TodoItem> tasks;

  const UserTodo({super.key, required this.tasks});

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<UserTodo> {
  final _textController = TextEditingController();
  bool _isEditing = true;

  List<TodoItem> get _assignments => widget.tasks;

  void _addOrEditTodo({TodoItem? item, bool isNew = false}) {
    final tempItem = item ??
        TodoItem(
          title: '',
          description: '',
          category: '',
          dueDate: null,
          priority: 'None',
        );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsPage(
          title: tempItem.title,
          initialDescription: tempItem.description ?? "",
          initialCategory: tempItem.category ?? "",
          initialDueDate: tempItem.dueDate,
          initialPriority: tempItem.priority ?? "None",
          onUpdate: (title, description, category, dueDate, priority) {
            setState(() {
              if (isNew) {
                _assignments.add(
                  TodoItem(
                    title: title,
                    description: description,
                    category: category,
                    dueDate: dueDate,
                    priority: priority,
                  ),
                );
              } else {
                item!.title = title;
                item.description = description;
                item.category = category;
                item.dueDate = dueDate;
                item.priority = priority;
              }
            });
          },
          onDelete: () {
            setState(() {
              if (!isNew) _assignments.remove(item);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDBBB6),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _isEditing
                      ? TextField(
                    controller: _textController,
                    style: const TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: 26,
                      color: Color(0xFF4F5A52),
                    ),
                    maxLength: 30,
                    decoration: InputDecoration(
                      hintText: 'Name your list!',
                      hintStyle: const TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: 26,
                        color: Color(0xFF4F5A52),
                      ),
                      counterText: "",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF73877B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          iconSize: 22,
                          icon: const Icon(Icons.save),
                          color: const Color(0xFFF5E4D7),
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                            });
                          },
                        ),
                      ),
                    ),
                  )
                      : Row(
                    children: [
                      Expanded(
                        child: Text(
                          _textController.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: 26,
                            color: Color(0xFF4F5A52),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF73877B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          iconSize: 22,
                          icon: const Icon(Icons.edit),
                          color: const Color(0xFFF5E4D7),
                          onPressed: () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF73877B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    iconSize: 22,
                    icon: const Icon(Icons.add),
                    color: const Color(0xFFF5E4D7),
                    onPressed: () => _addOrEditTodo(isNew: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: _assignments.length,
                itemBuilder: (context, index) {
                  final item = _assignments[index];
                  return ListItem(
                    title: item.title,
                    isDone: item.isDone,
                    onCheck: (val) {
                      setState(() {
                        item.isDone = val ?? false;
                      });
                    },
                    onTap: () => _addOrEditTodo(item: item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
