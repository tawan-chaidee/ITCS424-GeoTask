
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './todo_detail_page.dart';
import '../provider/todo_provider';

void main() {
  runApp(MainPage());
}

class TodoItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String startTime;
  final String endTime;
  final int index;

  const TodoItem({
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            // Pass in Todo list provider index to the TodoDetailPage
            pageBuilder: (context, animation, secondaryAnimation) =>
                TodoDetailPage(todoIndex: index),
          ),
        );
      },
      child: Container(
        width: 0.9 * MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$title, $startTime to $endTime',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.check,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
class FullWidthImage extends StatelessWidget {
  final String imageUrl;
  const FullWidthImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Image.network(
        imageUrl,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          const FullWidthImage(
              imageUrl:
                  'https://www.shutterstock.com/image-vector/map-city-600nw-671959120.jpg'),
          Expanded(
            child: ListView.builder(
              itemCount: todoProvider.todoList.length,
              itemBuilder: (context, index) {
                final todo = todoProvider.todoList[index];
                return GestureDetector(
                  child: TodoItem(
                    title: todo.title,
                    subtitle: todo.subtitle,
                    startTime: todo.startTime,
                    endTime: todo.endTime,
                    index: index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
